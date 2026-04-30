## MODIFIED Requirements

### Requirement: Motor de horarios usa asignaciones
El sistema SHALL leer el semestre del grupo al construir la lista de slots candidatos, invocando `assignable(turno, sem)` donde `sem` es el semestre del grupo objetivo. El motor SHALL generar sugerencias de **bloque** (dos franjas consecutivas del mismo día con el mismo maestro) como unidad primaria. Cuando no sea posible armar un bloque, el motor SHALL degradar a sugerencias de hora suelta. El motor SHALL continuar aplicando la regla de exclusión mutua entre los pares `(m4, mx)` y `(v4, vx)` en ambas franjas del bloque. Si `asignaciones.maestro_id` ya tiene valor para una asignación, el motor SHALL tratarlo como restricción dura: usará únicamente ese maestro y no buscará alternativas aunque no haya slots disponibles.

#### Scenario: Motor genera sugerencias para grupo de 1°
- **WHEN** se ejecuta el motor de asignación de slots para un grupo de 1° semestre matutino
- **THEN** el motor incluye `mx` como slot candidato y excluye `m4` para ese grupo (por `forSem`)

#### Scenario: Motor genera sugerencias para grupo de 4°
- **WHEN** se ejecuta el motor de asignación de slots para un grupo de 4° semestre matutino
- **THEN** el motor incluye `m4` como slot candidato y excluye `mx` para ese grupo (por `forSem`)

#### Scenario: Motor respeta exclusión mutua en bloques
- **WHEN** el maestro T05 ya tiene asignación en `m4` el lunes y el motor evalúa un bloque con slot candidato `mx` para T05 en otro grupo de 1°
- **THEN** el motor descarta ese bloque para T05 el lunes

#### Scenario: Motor respeta exclusión mutua (caso inverso)
- **WHEN** el maestro T05 ya tiene asignación en `mx` el martes y el motor evalúa slots para un grupo de 4° con T05
- **THEN** el motor descarta `m4` el martes para T05

#### Scenario: Motor usa asignaciones (comportamiento existente)
- **WHEN** se ejecuta el motor de asignación de slots para un grupo
- **THEN** el motor lee las materias y maestros desde `asignaciones` vinculadas al grupo, en lugar de la tabla `materias`

#### Scenario: Motor respeta maestro_id fijo — genera slots solo para ese maestro
- **WHEN** el motor procesa una asignación cuyo `maestro_id` ya tiene valor (ej. T03)
- **THEN** el motor SHALL usar T03 como único candidato, sin llamar a `competentTeachers()` para esa asignación

#### Scenario: Motor respeta maestro_id fijo — no reasigna aunque no haya slots
- **WHEN** el motor procesa una asignación con `maestro_id = T03` y T03 no tiene slots disponibles en ningún día
- **THEN** el motor SHALL emitir una sugerencia con `status = "no_slot"` manteniendo `teacherId = T03`; NO SHALL asignar a otro maestro

#### Scenario: Motor sin maestro_id — comportamiento actual
- **WHEN** el motor procesa una asignación cuyo `maestro_id` es null
- **THEN** el motor SHALL buscar candidatos mediante `competentTeachers(plantilla_id)` y seleccionar por disponibilidad y carga, igual que el comportamiento previo

#### Scenario: Sugerencia de bloque - aprobación escribe 2 celdas
- **WHEN** el admin aprueba una sugerencia de bloque (`slotB` presente)
- **THEN** el sistema SHALL escribir dos entradas en `schedule[cicloId][grupoId]`: una para `slotA_día` y otra para `slotB_día`, ambas con la misma materia y maestro

#### Scenario: Sugerencia de bloque - UI muestra rango horario
- **WHEN** se renderiza la lista de sugerencias y una sugerencia tiene `slotB`
- **THEN** el sistema SHALL mostrar el rango completo (ej. "7:00–8:40") en lugar de solo la hora de inicio del primer slot
