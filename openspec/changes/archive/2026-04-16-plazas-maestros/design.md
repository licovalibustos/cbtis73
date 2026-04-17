## Context

La tabla `maestros` actualmente almacena los datos mínimos para la operación del sistema de horarios (nombre, RFC, categoría, horas). El formato oficial de horarios del plantel requiere datos adicionales del expediente laboral: grado máximo de estudios, institución de egreso, especialidad académica y departamento (campos de encabezado), más las plazas presupuestales que detallan en qué plaza, con qué condición de nombramiento, desde qué fecha y en qué turno trabaja el maestro.

Un maestro puede tener múltiples plazas (relación 1:N). Las fechas de ingreso son por plaza porque pueden diferir.

## Goals / Non-Goals

**Goals:**
- Extender `maestros` con 4 campos de encabezado del expediente
- Crear tabla `maestros_plazas` con los campos de la plaza presupuestal
- Agregar UI para capturar/editar estos datos desde la vista Maestros
- Mantener compatibilidad total con el flujo de asignaciones y motor de horarios existente

**Non-Goals:**
- Modificar `maestros.html` (portal del maestro — solo captura disponibilidad)
- Cambiar el cálculo de carga horaria (`hrs_nom`, `hrs_carga` no se tocan)
- Validar o sincronizar con sistemas externos (SEP/DGETI)
- Generar el PDF del formato de horarios en esta iteración

## Decisions

**D1 — Tabla separada para plazas (1:N) vs columnas en `maestros`**

Alternativa descartada: agregar `plaza_1`, `plaza_2`… como columnas adicionales en `maestros`.

Se elige tabla separada `maestros_plazas` porque el número de plazas es variable por maestro (1–N observado en datos reales) y la relación 1:N es el modelo correcto. La alternativa con columnas fijas no es extensible y genera muchos NULLs.

**D2 — Fechas como `text` en formato `YYYYMM`**

Alternativa descartada: tipo `date` con día implícito `01`.

Se elige `text` validado en UI porque el documento fuente solo registra año+mes (ej. `201303`) y almacenar una fecha completa inventada genera confusión. La validación en captura (regex `/^\d{6}$/`) garantiza el formato. El display puede formatear `201303` → `Mar 2013`.

**D3 — CRUD de plazas inline en el panel de detalle del maestro**

Alternativa descartada: modal separado para plazas.

Se elige sección inline en el panel `maest-detail` porque las plazas son datos secundarios del maestro y editarlos en contexto es más natural. El patrón de lista editable está establecido en el sistema (ej. competencias).

**D4 — `condicion_nom` como smallint (1/2/3), `turno` como char(1) (M/V/A)**

Consistent con las convenciones existentes: `grupos.turno` ya usa `M`/`V`, y valores numéricos para enumeraciones simples (1=Base, 2=Interinato, 3=Otro) evitan typos y son fáciles de mapear a labels en JS.

**D5 — Carga de plazas: separada de `TEACHERS`, sin cachear en ciclo**

Las plazas son datos del maestro, no del ciclo. Se cargan como parte del `ensureTeachers()` extendido (o lazy al abrir el detalle del maestro) y se guardan en `TEACHERS[i].plazas = []`. No requieren un `ensure*` propio.

## Risks / Trade-offs

- **[Riesgo] Datos históricos vacíos** → Los 4 campos nuevos y las plazas serán `NULL`/vacías para todos los maestros existentes. El UI debe mostrar el estado vacío graciosamente y no bloquear el flujo de horarios. Mitigación: todos los campos son opcionales.

- **[Riesgo] RLS en `maestros_plazas`** → La tabla nueva necesita políticas en Supabase equivalentes a las de `maestros`. Mitigación: incluir el SQL de RLS en la migración.

- **[Trade-off] Carga adicional en `ensureTeachers`** → Al cargar plazas junto con maestros se añade una segunda query. Es aceptable dado que el número de maestros y plazas es pequeño (~80 maestros, ~200 plazas estimadas).

## Migration Plan

1. Ejecutar en Supabase SQL Editor:
   ```sql
   -- Fase 1: campos de encabezado en maestros
   ALTER TABLE maestros
     ADD COLUMN IF NOT EXISTS grado text,
     ADD COLUMN IF NOT EXISTS egresado_de text,
     ADD COLUMN IF NOT EXISTS especialidad_acad text,
     ADD COLUMN IF NOT EXISTS departamento text;

   -- Fase 2: tabla de plazas
   CREATE TABLE IF NOT EXISTS maestros_plazas (
     id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
     maestro_id text NOT NULL REFERENCES maestros(id) ON DELETE CASCADE,
     plaza text NOT NULL,
     fecha_ingreso_sep text,
     fecha_ingreso_dgeti text,
     condicion_nom smallint CHECK (condicion_nom IN (1,2,3)),
     turno char(1) CHECK (turno IN ('M','V','A'))
   );

   -- RLS (equivalente a maestros)
   ALTER TABLE maestros_plazas ENABLE ROW LEVEL SECURITY;
   CREATE POLICY "public read" ON maestros_plazas FOR SELECT USING (true);
   CREATE POLICY "anon write" ON maestros_plazas FOR ALL USING (true) WITH CHECK (true);
   ```

2. No requiere rollback destructivo — las columnas son nullable y la tabla nueva es independiente.
3. Los maestros existentes tendrán `grado = NULL` y sin plazas; el sistema sigue funcionando.
