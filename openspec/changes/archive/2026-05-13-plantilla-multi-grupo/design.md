## Context

El sistema de horarios detecta conflictos comparando si el mismo maestro está asignado a dos grupos distintos en el mismo slot/día. Esta lógica es correcta en general, pero falla para materias donde **un único maestro puede dar clase simultáneamente a varios grupos** (ej. SALUD EMS, materias trans-grupo).

Actualmente:
- `isConflict(tid, slotId, day, exGroup)` → devuelve `true` si el maestro tiene un slot activo en **cualquier** otro grupo, sin importar la materia.
- `detectConflicts()` → marca como conflicto cualquier par de grupos donde el mismo maestro comparte slot.
- Resultado: asignar manualmente SALUD EMS al mismo maestro en 5 grupos genera 5 pills rojos falsos.

Las materias multi-grupo **sólo se asignan manualmente** — el motor las ignora.

## Goals / Non-Goals

**Goals:**
- Permitir marcar una materia del catálogo como `permite_multi_grupo`.
- Que `isConflict` y `detectConflicts` no reporten conflicto cuando todos los slots involucrados tienen la misma materia multi-grupo con el mismo maestro.
- Toggle en la UI del catálogo para activar/desactivar el flag.
- Propagar el flag al copiar ciclo.

**Non-Goals:**
- El motor de asignación no asigna materias multi-grupo automáticamente.
- No se valida que todos los grupos del semestre tengan la materia asignada al mismo slot.
- No se cambia el esquema de la tabla `horario`.
- No hay estilo visual especial para celdas multi-grupo.

## Decisions

**D1 — Flag en `materias_catalogo`, no en `plantillas`**

Alternativas consideradas:
- A) Flag en `plantillas` (tabla global) → el flag sería por materia sin importar el ciclo.
- B) Flag en `materias_catalogo` (por ciclo) → permite que una materia sea multi-grupo en un ciclo y no en otro.

*Decisión: B.* Sigue el patrón del sistema donde el catálogo es por ciclo. Simplifica la lógica porque `ensureCatalogo` ya carga toda la fila incluyendo el nuevo flag.

---

**D2 — Lookup por nombre (`subjectName` text), no por FK**

La tabla `horario` almacena `materia_nombre` como texto (no hay FK a `materias_catalogo`). El schedule en memoria usa `schedule[cid][gid][key].subjectName` también como texto.

Alternativas consideradas:
- A) Añadir `plantilla_id` al horario para matching exacto → requiere schema change en `horario` + backfill.
- B) Matching por nombre → funciona con datos existentes, sigue el patrón actual del sistema.

*Decisión: B.* El nombre es el identificador funcional en toda la capa de schedule. El riesgo de desfase nombre/catálogo es bajo (el admin gestiona ambos).

---

**D3 — `multiGrupoNames` como `Set` global por cicloId, construido tras `ensureCatalogo`**

```javascript
// Global
const multiGrupoNames = {};   // multiGrupoNames[cicloId] = Set<string>

// En ensureCatalogo (o justo después de que se populea catalogo[cicloId]):
multiGrupoNames[cicloId] = new Set(
  (catalogo[cicloId] || []).filter(m => m.permite_multi_grupo).map(m => m.nombre)
);
```

Esto sigue el patrón `ensure*` del sistema. El Set se invalida junto con `catalogo[cicloId]` cuando se crea/edita una materia.

---

**D4 — `isConflict` recibe `subjectName` opcional (5.º parámetro)**

```javascript
function isConflict(tid, slotId, day, exGroup, subjectName = null)
```

Regla de exención: si el slot conflictivo en el otro grupo tiene la misma materia que la materia entrante, Y esa materia está en `multiGrupoNames`, → `continue` (no es conflicto).

Los callers del motor **no necesitan cambio** (el motor ya excluye estas materias). Los callers de UI pasan `subjectName` cuando está disponible.

---

**D5 — `detectConflicts` inspecciona los dos lados sin parámetro adicional**

`detectConflicts` ya tiene acceso a `.subjectName` en cada celda del schedule. Puede comprobar directamente si todos los grupos que comparten un slot/maestro tienen la misma materia multi-grupo.

## Risks / Trade-offs

- **[Riesgo] Desfase nombre-catálogo**: Si el admin renombra la materia en el catálogo después de crear slots, los `horario` existentes quedan con el nombre viejo y no se eximen del conflicto.
  → *Mitigación*: El riesgo es bajo; renombrar una materia ya implica revisar los slots. Documentar en UI que el nombre es el identificador.

- **[Riesgo] Ciclos anteriores**: `multiGrupoNames[cicloId]` depende de `catalogo[cicloId]`. Si el admin ve un ciclo anterior donde `permite_multi_grupo` no existía, el Set estará vacío → comportamiento idéntico al actual (conflictos reportados). Aceptable.

- **[Trade-off] Matching por nombre**: Menos robusto que una FK, pero evita un schema change más invasivo en `horario` y mantiene consistencia con el patrón actual.

## Migration Plan

1. Ejecutar en Supabase SQL:
   ```sql
   ALTER TABLE materias_catalogo
     ADD COLUMN IF NOT EXISTS permite_multi_grupo BOOLEAN NOT NULL DEFAULT false;
   ```
2. No se requiere backfill — default `false` mantiene comportamiento existente para todas las materias.
3. Despliegue: actualizar `sistema_horarios_v1.html` (single-file app, sin proceso de build).
4. Rollback: revertir el archivo HTML; las filas BD con `permite_multi_grupo=true` serán ignoradas por el client viejo.

## Open Questions

*Ninguna — el scope está cerrado antes de implementar.*
