## MODIFIED Requirements

### Requirement: El motor genera sugerencias de bloque de 2 horas consecutivas
El sistema SHALL generar sugerencias de bloque—compuestas por dos franjas horarias consecutivas del mismo día—como unidad primaria de asignación. Un bloque válido requiere que ambas franjas estén libres para el grupo y que el maestro esté disponible y sin conflicto en las dos. Los slots consecutivos se determinan por adyacencia en el array devuelto por `assignable(turno, sem)`, que ya excluye recesos. Antes de iterar grupos, el motor SHALL precargar la disponibilidad de todos los maestros desde la tabla `disponibilidad` usando `ensureDisponibilidad`, de modo que `availability[tid][cicloId]` nunca sea `undefined` durante la evaluación de slots.

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

#### Scenario: Motor no propone slot marcado como No disponible en modo Estricto
- **WHEN** el maestro T05 tiene el slot `m2_lunes` marcado como `unavail` en `disponibilidad` y el modo Estricto está activo
- **THEN** el motor SHALL descartar ese slot para T05 tanto en la fase de bloques como en la fase de horas sueltas, incluso si el admin nunca visitó la pantalla de disponibilidad de T05 en la sesión actual

#### Scenario: Disponibilidad precargada antes de iterar grupos
- **WHEN** el admin ejecuta el motor de asignación
- **THEN** el sistema SHALL cargar `ensureDisponibilidad` para todos los maestros antes de comenzar a generar sugerencias, de modo que `availability[tid][cicloId]` esté poblado

#### Scenario: Maestro con solo_grupos_objetivo no aparece en grupos no preferidos
- **WHEN** el maestro T10 tiene `solo_grupos_objetivo=true` y preferencias solo para los grupos 3AMA y 3AVA, y el motor procesa el grupo 3BMP
- **THEN** el motor SHALL excluir a T10 de los candidatos para cualquier materia del grupo 3BMP, incluso si T10 es el preferido general de esa plantilla

#### Scenario: Maestro con solo_grupos_objetivo cubre todos sus grupos preferidos aunque supere hrs_carga
- **WHEN** el maestro T10 tiene `solo_grupos_objetivo=true`, preferencias para 3AMA y 3AVA, `hrs_carga=20`, y las materias asignadas suman 24 horas
- **THEN** el motor SHALL proponer las 24 horas para T10 en sus grupos preferidos sin truncar por el límite de `hrs_carga`

#### Scenario: Maestro sin solo_grupos_objetivo sigue respetando hrs_carga
- **WHEN** el maestro T11 no tiene `solo_grupos_objetivo` y ya acumula `hrs_carga` horas asignadas
- **THEN** el motor SHALL no proponer horas adicionales para T11; el comportamiento de capacidad no cambia
