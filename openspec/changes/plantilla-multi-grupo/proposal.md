## Why

El sistema no permite que una materia sea impartida por el mismo maestro a múltiples grupos simultáneamente. Para materias como SALUD EMS, donde todos los grupos de un semestre asisten juntos, el sistema reporta falsos conflictos de horario al asignar el mismo maestro y slot a más de un grupo. Esto hace que el pill de conflictos sea poco confiable.

## What Changes

- **Nueva columna en catálogo**: `materias_catalogo.permite_multi_grupo` (boolean, default false) — marca que esa materia puede compartir maestro y slot entre varios grupos sin que sea conflicto.
- **Fix de detección de conflictos**: `isConflict()` y `detectConflicts()` ignorarán el choque si la materia del slot involucrado tiene `permite_multi_grupo = true`.
- **Toggle en UI de catálogo**: el formulario de edición de materia incluirá un toggle "Multi-grupo (varios grupos simultáneos)".

## Capabilities

### New Capabilities
- `plantilla-multi-grupo`: flag en materia del catálogo que permite asignar el mismo maestro al mismo slot en múltiples grupos sin reportar conflicto.

### Modified Capabilities
- ninguna

## Goals
- El pill de conflictos no se dispara para materias marcadas como multi-grupo.
- El admin puede marcar/desmarcar el flag desde la UI del catálogo.
- El horario por grupo y la vista por maestro siguen mostrando la información correctamente.

## Non-Goals
- El motor de asignación no intentará asignar automáticamente materias multi-grupo.
- No se modifican los datos de horario ya guardados en BD.
- No se cambia el esquema de la tabla `horario`.

## Impact

- `materias_catalogo`: nueva columna `permite_multi_grupo`.
- `sistema_horarios_v1.html`: funciones `isConflict`, `detectConflicts`, carga de catálogo, UI de edición de materia.
