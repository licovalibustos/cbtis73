## Why

El formato final de horarios requiere datos del expediente laboral del maestro que actualmente no se capturan: grado académico, institución de egreso, especialidad académica, departamento, y las plazas presupuestales con su fecha de ingreso (SEP/DGETI), condición de nombramiento y turno oficial. Sin estos datos el sistema no puede generar el documento oficial completo.

## What Changes

- Se agregan 4 columnas opcionales a `maestros`: `grado`, `egresado_de`, `especialidad_acad`, `departamento`
- Se crea la tabla `maestros_plazas` para almacenar las plazas presupuestales (relación 1:N con `maestros`)
- El formulario de alta/edición de maestros en `sistema_horarios_v1.html` incluye los 4 campos nuevos del encabezado y una sección CRUD inline para gestionar las plazas del maestro
- Los campos existentes (`hrs_nom`, `hrs_carga`, `categoria`, etc.) no cambian ni se reemplazan

## Capabilities

### New Capabilities
- `plazas-maestros`: Gestión de plazas presupuestales de los maestros (tabla detalle con plaza, fechas de ingreso SEP/DGETI, condición de nombramiento y turno oficial)

### Modified Capabilities
- `catalogo-maestros`: El formulario de maestros agrega 4 campos del encabezado del expediente (grado, egresado_de, especialidad_acad, departamento) y la sección de plazas

## Impact

- **DB**: `ALTER TABLE maestros` (+4 columnas); `CREATE TABLE maestros_plazas`
- **sistema_horarios_v1.html**: Modal/formulario de maestro (view `maestros`), función `saveTeacher`, `renderMaestroDetail`, carga inicial de datos
- **maestros.html**: Sin cambios (solo captura disponibilidad, no datos del expediente)
- **Supabase**: Nueva tabla requiere política RLS equivalente a la de `maestros`
