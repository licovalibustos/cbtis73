## ADDED Requirements

### Requirement: Vinculación de grupos a materias del catálogo
El sistema SHALL mantener registros en `asignaciones` que vinculan cada materia del catálogo con los grupos que la reciben, como base para el motor de asignación automática.

#### Scenario: Ver grupos vinculados a una materia
- **WHEN** el admin selecciona una materia del catálogo
- **THEN** el sistema muestra una tabla con todos los grupos del semestre correspondiente marcados como "✓ Incluido"; los registros en `asignaciones` se crean automáticamente con `maestro_id = null`

#### Scenario: El panel de materias es informativo, no asigna maestros
- **WHEN** el admin navega a la vista Materias
- **THEN** el sistema muestra qué grupos tienen cada materia; la asignación de maestros se realiza exclusivamente en el módulo "Asignación Automática"

#### Scenario: Un maestro asignado a múltiples grupos en la misma materia
- **WHEN** el motor asigna a RAYMUNDO MUÑOZ como maestro de "Inglés I" en los grupos 1AVTC, 1BVTC, 1CVTC y 1DVTC
- **THEN** el sistema registra 4 filas en `asignaciones` con el mismo `maestro_id` y distintos `grupo_id`, y el motor de horarios considera estos conflictos al asignar slots

#### Scenario: Filtrar grupos por especialidad en materias CFP
- **WHEN** el admin selecciona una materia CFP de la especialidad "L" (Laboratorio Clínico)
- **THEN** el sistema solo muestra los grupos cuyo campo `especialidad` es "L" (ej: 3AML, 3BML, 3AVL, 3BVL)

#### Scenario: Optativas — agregar/quitar grupos manualmente
- **WHEN** el admin agrega un grupo a una materia optativa
- **THEN** se crea un registro en `asignaciones` para ese par materia×grupo; se puede quitar con el botón ✕

#### Scenario: Vista de grupos sigue mostrando sus materias
- **WHEN** el admin navega al detalle de un grupo
- **THEN** el sistema muestra las materias asignadas a ese grupo (consultando `asignaciones` + `materias_catalogo`), con el maestro asignado por el motor a cada una

#### Scenario: Motor de horarios usa asignaciones
- **WHEN** se ejecuta el motor de asignación de slots para un grupo
- **THEN** el motor lee las materias y maestros desde `asignaciones` vinculadas al grupo, en lugar de la tabla `materias`
