## Requirements

### Requirement: El motor genera sugerencias de bloque de 2 horas consecutivas
El sistema SHALL generar sugerencias de bloque—compuestas por dos franjas horarias consecutivas del mismo día—como unidad primaria de asignación. Un bloque válido requiere que ambas franjas estén libres para el grupo y que el maestro esté disponible y sin conflicto en las dos. Los slots consecutivos se determinan por adyacencia en el array devuelto por `assignable(turno, sem)`, que ya excluye recesos.

#### Scenario: Materia de horas pares - se generan bloques completos
- **WHEN** el motor procesa una materia de 4 horas para un grupo
- **THEN** el sistema SHALL generar 2 sugerencias de bloque (cada una con `slotA` y `slotB`), distribuyendo los bloques en días distintos

#### Scenario: Materia de horas impares - último bloque es hora suelta
- **WHEN** el motor procesa una materia de 5 horas para un grupo
- **THEN** el sistema SHALL generar 2 sugerencias de bloque y 1 sugerencia de hora suelta (`slotB = null`), cubriendo las 5 horas en total

#### Scenario: No hay par disponible en ningún día - fallback a hora suelta
- **WHEN** el motor intenta colocar un bloque de 2 horas pero todos los días tienen bloqueada al menos una de las franjas necesarias
- **THEN** el sistema SHALL degradar a sugerencias de hora suelta (comportamiento previo) para las horas restantes, en lugar de dejarlas sin colocar

#### Scenario: Par válido requiere mismo maestro en ambas franjas
- **WHEN** el motor evalúa un par de slots (slotA, slotB) para un día dado
- **THEN** el sistema SHALL seleccionar un maestro que esté disponible y sin conflicto en AMBAS franjas; un maestro disponible solo en una de las dos es descartado como candidato para ese par

#### Scenario: Bloques respetan slots por semestre
- **WHEN** el motor genera bloques para un grupo de 1° semestre
- **THEN** los pares de slots considerados provienen del array `assignable('M', 1)` (o 'V' según turno), garantizando que no se use `m4` ni `v4` para semestres que corresponden a `mx`/`vx`
