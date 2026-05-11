## MODIFIED Requirements

### Requirement: Motor de horarios usa asignaciones
El sistema SHALL leer el semestre del grupo al construir la lista de slots candidatos, invocando `assignable(turno, sem)` donde `sem` es el semestre del grupo objetivo. El motor SHALL generar sugerencias de **bloque** (dos franjas consecutivas del mismo día con el mismo maestro) como unidad primaria. Cuando no sea posible armar un bloque, el motor SHALL degradar a sugerencias de hora suelta. El motor SHALL continuar aplicando la regla de exclusión mutua entre los pares `(m4, mx)` y `(v4, vx)`. Para cada combinación grupo + materia, el motor SHALL elegir un solo maestro y SHALL usar ese mismo maestro en todas las sugerencias de la materia; MUST NOT repartir la materia entre dos maestros. Si `asignaciones.maestro_id` ya tiene valor para una asignación, el motor SHALL tratarlo como restricción dura: usará únicamente ese maestro, propondrá las horas que alcance a cubrir y dejará faltantes si es necesario; MUST NOT reasignar las horas restantes a otro maestro.

#### Scenario: Motor genera sugerencias para grupo de 1°
- **WHEN** se ejecuta el motor de asignación de slots para un grupo de 1° semestre matutino
- **THEN** el motor incluye `mx` como slot candidato y excluye `m4` para ese grupo

#### Scenario: Motor genera sugerencias para grupo de 4°
- **WHEN** se ejecuta el motor de asignación de slots para un grupo de 4° semestre matutino
- **THEN** el motor incluye `m4` como slot candidato y excluye `mx` para ese grupo

#### Scenario: Motor respeta exclusión mutua en bloques
- **WHEN** el maestro T05 ya tiene asignación en `m4` el lunes y el motor evalúa un bloque con slot candidato `mx` para T05 en otro grupo de 1°
- **THEN** el motor descarta ese bloque para T05 el lunes

#### Scenario: Motor usa un solo maestro para toda la materia
- **WHEN** el motor procesa una materia de 8 horas para un grupo y encuentra un maestro candidato para esa materia
- **THEN** todas las sugerencias generadas para esa materia usan el mismo `teacherId`

#### Scenario: Motor con maestro fijo propone parcial sin reemplazo
- **WHEN** el motor procesa una asignación con `maestro_id = T03` y T03 solo puede cubrir 6 de 8 horas
- **THEN** el motor propone únicamente 6 horas con T03, deja 2 horas faltantes y MUST NOT asignarlas a otro maestro

#### Scenario: Motor con preferido propone parcial sin repartir
- **WHEN** la opción de priorizar maestro preferido está activa y el maestro preferido solo puede cubrir parte de la materia
- **THEN** el motor usa solo a ese maestro preferido para la materia, propone las horas posibles y deja faltantes sin introducir un segundo maestro

#### Scenario: Motor sin fijo ni preferido elige un solo maestro
- **WHEN** la materia no tiene `maestro_id` fijo ni preferido aplicable
- **THEN** el motor selecciona un único maestro competente para esa materia y propone únicamente horas con ese maestro

#### Scenario: Sugerencia de bloque - aprobación escribe 2 celdas
- **WHEN** el admin aprueba una sugerencia de bloque (`slotB` presente)
- **THEN** el sistema SHALL escribir dos entradas en `schedule[cicloId][grupoId]` con la misma materia y el mismo maestro

#### Scenario: Sugerencia de bloque - UI muestra rango horario
- **WHEN** se renderiza la lista de sugerencias y una sugerencia tiene `slotB`
- **THEN** el sistema SHALL mostrar el rango completo en lugar de solo la hora de inicio del primer slot