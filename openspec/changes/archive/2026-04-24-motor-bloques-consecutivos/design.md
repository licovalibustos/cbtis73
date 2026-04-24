## Context

El motor actual (`runEngine()` en `sistema_horarios_v1.html`) genera sugerencias slot-por-slot iterando `slot → día`. Cada sugerencia tiene `{ slotId, dayIdx, teacherId }` y representa una sola franja horaria. Para una materia de 5 horas se generan 5 sugerencias independientes, una por día de la semana.

La práctica del plantel requiere bloques de 2 horas consecutivas: una materia de 5 horas debe distribuirse como 2+2+1 en 3 días, no 1+1+1+1+1 en 5 días. El maestro debe ser el mismo en ambas horas del bloque.

Los slots disponibles se obtienen de `assignable(turno, sem)` que ya filtra recesos — los índices adyacentes `[i, i+1]` en el array resultante son automáticamente pares válidos (incluyendo el caso m3+mx después del receso del turno matutino en sem 1-2).

## Goals / Non-Goals

**Goals:**
- El motor genera sugerencias de bloque (slotA + slotB del mismo día) prioritariamente
- Si no hay par disponible en ningún día, el motor degrada a 1 hora suelta
- El mismo maestro cubre ambas franjas del bloque
- La UI refleja el rango completo del bloque: "7:00–8:40" en lugar de "7:00–7:50"
- Aprobar un bloque escribe 2 celdas al schedule en un solo gesto

**Non-Goals:**
- Bloques de 3 horas o más
- Modificar la representación en `schedule` storage (sigue siendo celdas individuales)
- Cambiar `renderHorario()`, `isConflict()`, `isUnavail()`, `renderMvHorario()`
- Cambios en base de datos (ninguna tabla afectada)
- Gestión de horas de laboratorio (`hrs_lab`) — se deja para un change posterior

## Decisions

**D1 — Sugerencia = bloque: `{ slotA, slotB|null, dayIdx, ... }`**

Alternativa descartada: mantener sugerencias individuales pero generarlas en pares (campo `paired_with_idx`). Esto preserva la forma actual pero pierde la intención — el admin no sabría que "estas dos deben ir juntas".

Decisión: cambiar el shape del objeto `suggestion` para incluir `slotA` (antes `slotId`) y `slotB` (null cuando se degradó a hora suelta). `approveSug()` escribe ambas celdas en una sola operación.

**D2 — Iterar día → par de slots (invertir el loop)**

Alternativa descartada: iterar slot → slot_siguiente → días. El problema es que produce distribución desbalanceada: llena todos los días del primer par antes de usar el segundo par.

Decisión: el loop externo es el día (`d = 0..4`), el interno busca el primer par `[slots[i], slots[i+1]]` donde ambas franjas estén libres para el grupo y el maestro esté disponible y sin conflicto en ambas. Esto distribuye los bloques entre días naturalmente.

**D3 — Fallback a 1 hora si no hay par disponible**

Si `hrsLeft > 0` y no quedan días con par disponible, el motor intenta colocar horas sueltas con el loop original (slot → día). Si `hrsLeft` es impar al final de la fase de bloques, la hora residual también va como hora suelta.

Esto preserva el comportamiento actual como "peor caso" en lugar de dejar horas sin colocar innecesariamente.

**D4 — Validación del par con funciones existentes sin modificarlas**

`isConflict(tid, slotId, day, exGroup)` e `isUnavail(tid, slotId, day)` se llaman dos veces (una por franja). No requieren modificaciones. El score del bloque usa el mínimo de disponibilidad de ambas franjas.

## Risks / Trade-offs

- **[Risk] Más difícil llenar la carga completa** — Con bloques, se necesitan días con 2 franjas libres simultáneamente. Un horario con muchas materias ligeras (1-2 hrs) puede fragmentar días y dificultar armar bloques para materias grandes. → Mitigation: fallback D3 garantiza que siempre se coloca algo.
- **[Risk] Sugerencias generadas son menos** — Para una materia de 4 horas, el motor genera 2 sugerencias (2 bloques) en lugar de 4. El admin tiene menos granularidad pero el resultado es pedagógicamente correcto. → Aceptado por diseño.
- **[Trade-off] `hrs_lab` queda sin cambio por ahora** — Las horas de laboratorio siguen con el comportamiento de hora suelta. Se documenta como deuda técnica para siguiente change.
