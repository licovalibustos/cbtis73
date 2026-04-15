## ADDED Requirements

### Requirement: Definición correcta de slots de transición por semestre
El sistema SHALL definir los slots `mx` y `vx` con `forSem:[1,2]` (sin `blocked:true`), y los slots `m4` y `v4` con `forSem:[3,4,5,6]`, de forma que cada slot solo sea asignable a grupos del semestre correspondiente.

#### Scenario: mx visible como slot normal para grupos de 1°-2°
- **WHEN** el motor genera sugerencias para un grupo de 1° o 2° semestre en turno Matutino
- **THEN** el slot `mx` (9:50–10:40) aparece en la lista de slots candidatos y puede recibir una asignación si el maestro tiene disponibilidad

#### Scenario: mx no disponible para grupos de 3°-6°
- **WHEN** el motor genera sugerencias para un grupo de 3°-6° semestre en turno Matutino
- **THEN** el slot `mx` no aparece en la lista de slots candidatos

#### Scenario: vx visible para grupos de 1°-2° en vespertino
- **WHEN** el motor genera sugerencias para un grupo de 1° o 2° semestre en turno Vespertino
- **THEN** el slot `vx` (16:15–17:00) aparece como candidato si el maestro tiene disponibilidad

#### Scenario: vx no disponible para grupos de 3°-6°
- **WHEN** el motor genera sugerencias para un grupo de 3°-6° semestre en turno Vespertino
- **THEN** el slot `vx` no aparece en la lista de candidatos

---

### Requirement: assignable filtra slots por semestre del grupo
El sistema SHALL proveer `assignable(turno, sem)` que, dado un turno y un semestre, retorne únicamente los slots sin `recess:true` ni `blocked:true` cuyo `forSem` incluya `sem` (o que no tengan `forSem`).

#### Scenario: Slot sin forSem es válido para todos los semestres
- **WHEN** se llama `assignable('M', 4)` y el slot `m1` no tiene `forSem`
- **THEN** `m1` está incluido en el resultado

#### Scenario: Slot con forSem solo incluye semestres listados
- **WHEN** se llama `assignable('M', 3)` y el slot `mx` tiene `forSem:[1,2]`
- **THEN** `mx` no está en el resultado

---

### Requirement: Exclusión mutua entre slots solapados del mismo maestro
El sistema SHALL detectar como conflicto cuando un maestro ya tiene asignado el slot `m4` en un día y se intenta asignar `mx` el mismo día (y viceversa), así como `v4`/`vx` en turno vespertino.

#### Scenario: Conflicto m4 bloquea mx mismo día
- **WHEN** el maestro T05 ya tiene asignación en `m4` el martes y se evalúa asignarle `mx` el martes
- **THEN** `isConflict` retorna `true` y el motor no usa ese slot

#### Scenario: Conflicto mx bloquea m4 mismo día
- **WHEN** el maestro T05 ya tiene asignación en `mx` el jueves y se evalúa asignarle `m4` el jueves
- **THEN** `isConflict` retorna `true` y el motor no usa ese slot

#### Scenario: Conflicto v4/vx en vespertino
- **WHEN** el maestro T05 ya tiene asignación en `v4` el lunes y se evalúa asignarle `vx` el lunes
- **THEN** `isConflict` retorna `true`

#### Scenario: Sin conflicto entre días distintos
- **WHEN** el maestro T05 tiene `m4` el lunes y se evalúa `mx` el martes
- **THEN** `isConflict` retorna `false`; el slot es candidato válido

---

### Requirement: Slots de receso seleccionables en grilla de disponibilidad admin
El sistema SHALL renderizar los slots de receso (`r2a`, `r46a`, `r2b`, `r46b`) como celdas interactivas seleccionables en `renderDispGrid()`, con estilo visual ámbar distinto a los slots de clase normales.

#### Scenario: Admin puede marcar disponibilidad en receso
- **WHEN** el admin visualiza la grilla de disponibilidad de un maestro
- **THEN** las franjas de receso aparecen como celdas activas (no divisores), con color ámbar, y se pueden activar/desactivar

#### Scenario: setAll incluye celdas de receso
- **WHEN** el admin presiona "Todos disponibles" para un turno
- **THEN** las celdas de receso también quedan marcadas como disponibles

---

### Requirement: Slots de receso seleccionables en grilla de maestro (maestro.html)
El sistema SHALL renderizar los slots de receso como celdas interacticas en la grilla de disponibilidad del maestro en `maestro.html`, con el mismo estilo ámbar.

#### Scenario: Maestro puede marcar receso como disponible
- **WHEN** el maestro abre su link de disponibilidad y ve la grilla
- **THEN** las franjas de receso son celdas activas y seleccionables, no divisores grises

#### Scenario: La selección de receso se guarda en disponibilidad
- **WHEN** el maestro activa una celda de receso (ej. `r2a` el lunes)
- **THEN** al guardar, se persiste la entrada `r2a_0` en la tabla `disponibilidad` para ese maestro y ciclo

---

### Requirement: renderHorario muestra mx/vx como slots normales
El sistema SHALL mostrar los slots `mx` y `vx` en la vista de horario de grupos de 1°-2° semestre como celdas de clase normales (no divisores ni franjas bloqueadas).

#### Scenario: Horario de grupo de 1° muestra mx con materia asignada
- **WHEN** el admin visualiza el horario de un grupo de 1° semestre que tiene una asignación en `mx` el miércoles
- **THEN** la celda `mx`-miércoles muestra el nombre de la materia y el maestro, igual que cualquier otro slot

#### Scenario: Horario de grupo de 3° no muestra mx
- **WHEN** el admin visualiza el horario de un grupo de 3° semestre
- **THEN** la fila `mx` no aparece en la cuadrícula de ese grupo
