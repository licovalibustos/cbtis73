## Context

Actualmente `competencias[maestro_id]` es un `Set<string>` de nombres en mayúsculas. El match con el catálogo se hace por comparación exacta de string en `competentTeachers()` y `runEngine`. No hay validación: un typo o una corrección de nombre en `materias_catalogo` rompe silenciosamente todas las competencias relacionadas sin ningún aviso al usuario ni al motor.

La tabla `materias_catalogo` es por ciclo (instancias), pero los nombres de materias son esencialmente estables — los define la SEP. Lo que falta es una entidad global que represente "la materia como concepto" y que sirva como ancla para competencias y para los catálogos de cada ciclo.

## Goals / Non-Goals

**Goals:**
- Eliminar el match frágil por string; competencias apuntan a un id estable
- Introducir `materias_plantilla` como catálogo global de nombres canónicos
- Migrar datos existentes sin pérdida
- UI: modal de competencias usa picker en lugar de input libre
- El motor sigue funcionando igual, solo cambia cómo resuelve el match

**Non-Goals:**
- No cambiar la estructura de `asignaciones`, `disponibilidad`, ni `horario`
- No agregar versionado de plantillas ni historial de cambios de nombre
- No cambiar la lógica del motor más allá del lookup de competencias

## Decisions

**D1 — Nueva tabla `materias_plantilla` en lugar de normalizar `materias_catalogo`**

Se introduce una tabla global separada en lugar de intentar deduplicar nombres dentro de `materias_catalogo`:

```
materias_plantilla
  id   uuid PK
  nombre  text UNIQUE NOT NULL
```

`materias_catalogo` agrega `plantilla_id uuid REFERENCES materias_plantilla(id)`. El campo `nombre` en `materias_catalogo` se vuelve redundante y puede ser eliminado later o mantenido como caché desnormalizado.

_Alternativa descartada_: FK directa de `competencias` a `materias_catalogo`. Rechazada porque el `id` de catálogo es por ciclo — los maestros tendrían que re-registrar sus competencias cada semestre.

_Alternativa descartada_: Mantener string pero normalizar con lookup al guardar. Rechazada porque el problema persiste si se renombra una plantilla posteriorment.

---

**D2 — `competencias` guarda `plantilla_id`, no `materia` text**

```sql
ALTER TABLE competencias
  ADD COLUMN plantilla_id uuid REFERENCES materias_plantilla(id),
  DROP COLUMN materia;
```

`competencias[maestroId]` en memoria cambia de `Set<string>` a `Set<uuid>`. `competentTeachers(plantillaId)` recibe uuid en lugar de string.

_Alternativa descartada_: Mantener ambos campos en paralelo durante transición. Innecesariamente complejo para una app de un solo admin.

---

**D3 — `nombre` en `materias_catalogo` se mantiene como campo independiente (no derivado)** _(deferred — no implementado en esta iteración)_

Cada instancia en el catálogo puede tener un nombre levemente ajustado (e.g. "INGLÉS IV Sem A") sin tocar la plantilla. La plantilla es el nombre canónico; el catálogo puede especializarlo.

_Alternativa descartada_: Hacer `nombre` un campo calculado desde `plantilla.nombre`. Demasiado rígido para ajustes operativos por ciclo.

_Nota de implementación_: La UX del modal de catálogo usa input de texto simple con auto-resolve (el `nombre` del catálogo siempre coincide con el nombre de la plantilla). La posibilidad de especializar el nombre por ciclo queda como mejora futura.

---

**D4 — `ensurePlantillas()` carga el catálogo global al inicio**

Nuevo loader que carga `materias_plantilla` completo en memoria (`plantillas[]`) una sola vez. No está keyed por ciclo. Se llama en `init()` junto con `ensureCompetencias()`.

---

**D5 — El modal de competencias muestra picker filtrable desde `plantillas[]`**

`compSuggest()` cambia de `allSubjectNames()` (que itera `subjects` por ciclo) a filtrar `plantillas` en memoria. El administrador puede crear nuevas plantillas inline si la materia no existe aún.

## Risks / Trade-offs

**[Risk] Migration falla si hay nombres duplicados con distintos acentos** → Pre-migration: `SELECT nombre, COUNT(*) FROM materias_catalogo GROUP BY UPPER(nombre) HAVING COUNT(*) > 1` para identificar y normalizar antes. La migration deduplica por `UPPER(TRIM(nombre))`.

**[Risk] Competencias existentes se pierden si la migration no mapea correctamente** → La migration incluye verificación: `SELECT COUNT(*) FROM competencias WHERE plantilla_id IS NULL` debe ser 0 antes de hacer la constraint NOT NULL.

**[Risk] `horario` guarda `materia_nombre` como texto** → Este campo no cambia. El nombre en horario es histórico/display y no participa en el match de competencias. Sin riesgo.

**[Trade-off] Más una tabla más en queries de catálogo** → Los joins son simples (plantilla_id FK) y PostgREST los resuelve automáticamente con `select=*,materias_plantilla(*)`.

## Migration Plan

```sql
-- 1. Crear tabla global
CREATE TABLE materias_plantilla (
  id     uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre text UNIQUE NOT NULL
);

-- 2. Poblar desde nombres únicos del catálogo (normalizados)
INSERT INTO materias_plantilla (nombre)
SELECT DISTINCT UPPER(TRIM(nombre))
FROM materias_catalogo
ORDER BY 1;

-- 3. Agregar FK a catalogo
ALTER TABLE materias_catalogo
  ADD COLUMN plantilla_id uuid REFERENCES materias_plantilla(id);

UPDATE materias_catalogo mc
SET plantilla_id = mp.id
FROM materias_plantilla mp
WHERE UPPER(TRIM(mc.nombre)) = mp.nombre;

-- 4. Migrar competencias
ALTER TABLE competencias
  ADD COLUMN plantilla_id uuid REFERENCES materias_plantilla(id);

UPDATE competencias c
SET plantilla_id = mp.id
FROM materias_plantilla mp
WHERE UPPER(TRIM(c.materia)) = mp.nombre;

-- 5. Verificar antes de hacer NOT NULL
-- SELECT COUNT(*) FROM competencias WHERE plantilla_id IS NULL; -- debe ser 0
-- SELECT COUNT(*) FROM materias_catalogo WHERE plantilla_id IS NULL; -- debe ser 0

-- 6. Finalizar constraints
ALTER TABLE competencias
  ALTER COLUMN plantilla_id SET NOT NULL,
  DROP COLUMN materia;

-- Rollback: DROP TABLE materias_plantilla CASCADE revertirá todo si se hace antes del step 6
```

**Rollback**: Antes del step 6, hacer `DROP TABLE materias_plantilla CASCADE` revierte todo. Después del step 6, se necesita restore desde backup.

## Open Questions

- ¿Se debe mostrar un aviso cuando una competencia apunta a una plantilla que ya no tiene instancias en el ciclo actual? (Por ahora: no, el motor simplemente no la usa.)
- ¿Las plantillas se pueden eliminar? → Solo si no tienen competencias ni instancias de catálogo asociadas. Validar en UI antes de DELETE.
