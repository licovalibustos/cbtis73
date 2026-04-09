## Why

El sistema actual duplica cada materia por grupo: si 16 grupos de 1er semestre tienen "Inglés I", hay 16 filas idénticas en la base de datos. Esto impide ver de un vistazo quién da cada materia en cada grupo, complica la asignación de maestros, y no refleja cómo la escuela realmente gestiona su distribución académica (un Excel por ciclo donde las materias son columnas y los grupos son filas).

## What Changes

- **BREAKING** La tabla `materias` es reemplazada por dos tablas: `materias_catalogo` y `asignaciones`
- Las materias se definen una sola vez por ciclo+semestre, no por grupo
- Se introduce el campo `tipo` para diferenciar materias troncales, optativas y CFP (Componente de Formación Profesional)
- Las materias CFP tienen sub-módulos con horas de aula y horas de laboratorio separadas `(hrs_aula/hrs_lab)`
- El maestro se asigna en `asignaciones` (por grupo), no en el catálogo
- La pantalla de Materias se rediseña para ser materia-céntrica: se ve una materia y todos los grupos que la tienen, en lugar de ver un grupo y todas sus materias
- El motor de asignación de horarios se actualiza para leer desde `asignaciones` en lugar de `materias`

## Capabilities

### New Capabilities

- `catalogo-materias`: Gestión del catálogo de materias por ciclo y semestre, con tipos (troncal, optativa, cfp) y especialidad
- `asignacion-maestros`: Asignación de maestro por tupla materia×grupo, replicando la "Distribución" del Excel institucional

### Modified Capabilities

- (no hay specs existentes que modificar)

## Impact

- **Base de datos (Supabase)**: crear `materias_catalogo` y `asignaciones`, migrar datos de `materias`
- **`sistema_horarios_v1.html`**: vista Materias completa, funciones `renderMaterias`, `saveMateria`, `delMateria`, `ensureSubjects`, motor `runEngine`
- **Lectura en horario/impresión**: el nombre de materia y maestro se resuelven desde `asignaciones`
