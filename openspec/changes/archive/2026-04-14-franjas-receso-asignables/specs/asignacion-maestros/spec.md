## MODIFIED Requirements

### Requirement: Motor de horarios usa asignaciones
El sistema SHALL leer el semestre del grupo al construir la lista de slots candidatos, invocando `assignable(turno, sem)` donde `sem` es el semestre del grupo objetivo, de modo que solo se consideren slots válidos para ese semestre. Además, el motor SHALL aplicar la regla de exclusión mutua entre los pares `(m4, mx)` para turno Matutino y `(v4, vx)` para turno Vespertino: si el maestro ya tiene una asignación en uno del par en el día candidato, el otro slot del par se descarta.

#### Scenario: Motor genera sugerencias para grupo de 1°
- **WHEN** se ejecuta el motor de asignación de slots para un grupo de 1° semestre matutino
- **THEN** el motor incluye `mx` como slot candidato y excluye `m4` para ese grupo (por `forSem`)

#### Scenario: Motor genera sugerencias para grupo de 4°
- **WHEN** se ejecuta el motor de asignación de slots para un grupo de 4° semestre matutino
- **THEN** el motor incluye `m4` como slot candidato y excluye `mx` para ese grupo (por `forSem`)

#### Scenario: Motor respeta exclusión mutua
- **WHEN** el maestro T05 ya tiene asignación en `m4` el lunes y el motor evalúa slots para otro grupo de 1° con T05
- **THEN** el motor descarta `mx` el lunes para T05 aunque T05 tenga disponibilidad marcada en `mx_0`

#### Scenario: Motor respeta exclusión mutua (caso inverso)
- **WHEN** el maestro T05 ya tiene asignación en `mx` el martes y el motor evalúa slots para un grupo de 4° con T05
- **THEN** el motor descarta `m4` el martes para T05

#### Scenario: Motor usa asignaciones (comportamiento existente)
- **WHEN** se ejecuta el motor de asignación de slots para un grupo
- **THEN** el motor lee las materias y maestros desde `asignaciones` vinculadas al grupo, en lugar de la tabla `materias`
