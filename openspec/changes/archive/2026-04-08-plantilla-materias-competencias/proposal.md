## Why

Las competencias de maestros se guardan como strings de texto libre (`materia: "INGLÉS IV"`), haciendo el match frágil ante typos o correcciones de nombre. Si un admin corrige el nombre de una materia en el catálogo, todas las competencias asociadas quedan rotas silenciosamente y el motor de asignación nunca sugiere esos maestros.

## What Changes

- **Nueva tabla `materias_plantilla`** — catálogo global de materias (independiente de ciclo), con `id` uuid y `nombre` único. Es la fuente de verdad para los nombres.
- **`materias_catalogo` agrega `plantilla_id`** — FK a `materias_plantilla`. El catálogo por ciclo instancia la plantilla; `nombre` se vuelve derivado.
- **`competencias` cambia `materia` text → `plantilla_id` uuid** — **BREAKING**: el string libre se reemplaza por FK a la plantilla global.
- **Modal de competencias** — reemplaza input libre por picker de materias_plantilla con búsqueda.
- **Migration** — convertir strings existentes en registros de plantilla y actualizar FKs.

## Capabilities

### New Capabilities
- `plantilla-materias`: Catálogo global de materias (sin ciclo) que sirve como fuente de verdad para nombres; permite corregir un nombre una sola vez y propagarlo automáticamente.

### Modified Capabilities
- `asignacion-maestros`: El match de competencias cambia de comparación de strings a FK — impacta `competentTeachers()`, `runEngine`, `compSuggest`, `saveComp`, `ensureCompetencias`.
- `catalogo-materias`: Al crear/editar una materia en el catálogo, el nombre se elige desde `materias_plantilla` en lugar de texto libre.

## Impact

- **DB**: Nueva tabla `materias_plantilla`; alter `materias_catalogo` (add `plantilla_id`); alter `competencias` (replace `materia` text con `plantilla_id` uuid)
- **JS**: `ensureCompetencias`, `competentTeachers`, `runEngine`, `compSuggest`, `saveComp`, `openCompModal`, `saveMateriasCatalogo`, `ensureCatalogo`
- **Migration**: script SQL para poblar `materias_plantilla` desde nombres únicos existentes y actualizar FKs
- **Sin impacto**: `disponibilidad`, `horario`, `grupos`, `maestros`, `asignaciones` (sin cambios)
