## 1. Definición de SLOTS (sistema_horarios_v1.html)

- [x] 1.1 Remover `blocked:true` del slot `mx` y agregar `forSem:[1,2]`
- [x] 1.2 Remover `blocked:true` del slot `vx` y agregar `forSem:[1,2]`
- [x] 1.3 Agregar `forSem:[3,4,5,6]` a `m4`
- [x] 1.4 Agregar `forSem:[3,4,5,6]` a `v4`
- [x] 1.5 Agregar constante `MUTEX_SLOTS = [['m4','mx'],['v4','vx']]` junto a la definición de SLOTS

## 2. Función assignable (sistema_horarios_v1.html)

- [x] 2.1 Cambiar la firma de `assignable` de `t => ...` a `(t, sem) => ...`
- [x] 2.2 Actualizar el filtro para incluir `!s.forSem || s.forSem.includes(sem)` además de `!s.recess && !s.blocked`
- [x] 2.3 Actualizar todos los call sites de `assignable(turno)` que estén en el motor de sugerencias para pasar el semestre del grupo (`assignable(grupo.turno, grupo.semestre)`)

## 3. Detección de conflictos (sistema_horarios_v1.html)

- [x] 3.1 En `isConflict(tid, slotId, day, exGroup)`, agregar chequeo de `MUTEX_SLOTS`: si `slotId` es par de algún slot ya ocupado por `tid` en `day`, retornar `true`
- [x] 3.2 Verificar que `detectConflicts()` no requiere cambios adicionales (usa `isConflict` internamente)

## 4. UI — Grid de disponibilidad admin (sistema_horarios_v1.html)

- [x] 4.1 En `renderDispGrid()`, cambiar la condición `if(slot.recess||slot.blocked)` para que los slots con `recess:true` se rendericen como celdas seleccionables con clase `slot-recess` (ámbar) en lugar de divisores
- [x] 4.2 Agregar el estilo CSS para `.slot-recess` (fondo ámbar, opacidad reducida cuando inactivo, color normal cuando activo)
- [x] 4.3 En `setAll()`, verificar que incluye las celdas de receso al marcar "todos disponibles"

## 5. UI — Vista de horario admin (sistema_horarios_v1.html)

- [x] 5.1 En `renderHorario()`, mostrar los slots `mx` y `vx` como filas normales para grupos de semestre 1 y 2 (en lugar de omitirlos o mostrarlos como divisores)
- [x] 5.2 Verificar que para grupos de semestre 3-6, `mx`/`vx` no aparecen en la cuadrícula de horario

## 6. Definición de SLOTS y grid de disponibilidad (maestro.html)

- [x] 6.1 Replicar los cambios de la tarea 1 en la definición de `SLOTS` de `maestro.html`
- [x] 6.2 Replicar la constante `MUTEX_SLOTS` en `maestro.html`
- [x] 6.3 En `maestro.html`, cambiar el renderizado de slots de receso en la grilla para que sean celdas seleccionables con estilo ámbar (mismo patrón que tarea 4.1)
- [x] 6.4 Agregar el estilo CSS `.slot-recess` en `maestro.html`

## 7. Validación y pruebas manuales

- [x] 7.1 Verificar en la grilla admin: los slots de receso aparecen en ámbar y son clicables; al guardar se persisten correctamente en `disponibilidad`
- [x] 7.2 Verificar en `maestro.html`: recesos aparecen en ámbar y son seleccionables; al guardar se persiste la clave `r2a_0`, `r46a_1`, etc.
- [x] 7.3 Ejecutar motor para un grupo de 1° semestre matutino y verificar que `mx` aparece como candidato
- [x] 7.4 Ejecutar motor para un grupo de 4° semestre matutino y verificar que `mx` NO aparece como candidato
- [x] 7.5 Asignar manualmente `m4` a T01 el lunes; ejecutar motor para grupo 1° con T01 y verificar que `mx` el lunes no aparece (exclusión mutua)
- [x] 7.6 Verificar que el horario de un grupo de 1° semestre muestra correctamente las asignaciones en `mx`
- [x] 7.7 Verificar que el horario de un grupo de 3° semestre no muestra la fila `mx`
