## Context

Los slots `mx` (9:50–10:40 matutino) y `vx` (16:15–17:00 vespertino) están marcados `blocked:true` en la constante `SLOTS`, lo que impide al motor usarlos para grupos de 1°-2° semestre. Esos son horarios reales de clase: mientras los grupos 3°-6° tienen su receso (9:30–9:50 o 10:20–10:40), los grupos 1°-2° tienen clase (`mx`/`vx`). El motor nunca ha podido generar asignaciones correctas para 1°-2° en la franja de transición. Adicionalmente, los slots de receso (`r2a`, `r46a`, `r2b`, `r46b`) se renderizan como divisores no interactivos, lo que impide capturar disponibilidad del maestro en esos minutos.

## Goals / Non-Goals

**Goals:**
- Corregir la definición de `SLOTS` para que `mx`/`vx` sean asignables (con `forSem:[1,2]`)
- Parametrizar `assignable(turno, sem)` para que respete `forSem` en cada slot
- Detectar conflicto de solapamiento temporal entre `m4`/`mx` (y `v4`/`vx`) para el mismo maestro en el mismo día
- Mostrar slots de receso como celdas seleccionables (ámbar) en grillas de disponibilidad de ambos archivos
- Actualizar `maestro.html` con la misma definición de `SLOTS`

**Non-Goals:**
- Cambios en el esquema SQL de Supabase
- Migración de datos de disponibilidad existentes
- Cambiar la semántica de los slots de receso como clase — siguen siendo recesos, solo se vuelven seleccionables para captura de disponibilidad

## Decisions

**D1: `forSem` como array en cada slot; `assignable(turno, sem)` filtra por él**

Alternativas consideradas:
- A) Tabla separada slot×semestre — más flexible pero sobrecomplica el modelo para un problema acotado
- B) Añadir `forSem` al objeto slot con array de semestres válidos — costo mínimo, legible

Decisión (B): si el slot no tiene `forSem`, es válido para todos los semestres. La firma cambia a `assignable(turno, sem)` y el filtro aplica `!s.forSem || s.forSem.includes(sem)`. Todos los call sites que pasaban solo el turno deben pasar también el semestre del grupo.

**D2: Exclusión mutua `m4`/`mx` y `v4`/`vx` como lista de pares**

Los slots se solapan en tiempo real:
- `m4` 9:30–10:20 ↔ `mx` 9:50–10:40 → 30 min de overlap
- `v4` 15:55–16:40 ↔ `vx` 16:15–17:00 → 25 min de overlap

Alternativas consideradas:
- A) Calcular conflicto por timestamps parseados desde los labels — frágil ante cambios de texto
- B) Lista de pares mutuamente excluyentes codificada — simple, explícita, mantenible

Decisión (B): constante `MUTEX_SLOTS = [['m4','mx'],['v4','vx']]`. En `isConflict()`, además del chequeo por `slotId_day`, se verifica si el slot a asignar es "gemelo conflictivo" de algún slot ya ocupado del maestro ese día.

**D3: Slots de receso seleccionables sin ser asignables a materias**

Los slots `r2a`, `r46a`, `r2b`, `r46b` pueden marcarse como disponibles en la grilla pero el motor nunca los tomará para asignar clases (no tienen `forSem` que coincida con ningún grupo real de ningún semestre en esos slots). Solo capturan presencia física del maestro para fines informativos o de guardia.

Decisión: no añadir `forSem` a los slots de receso, mantener `recess:true`. El renderizado los muestra con clase `slot-recess` (ámbar) como celdas interactivas. El motor los ignora naturalmente porque `assignable()` excluye `recess:true`.

## Risks / Trade-offs

- [Riesgo] Registros existentes en `disponibilidad` no tienen entradas para `mx`/`vx` ni para slots de receso → Se tratan como `false` (no disponible), que es el default conservador correcto. Sin impacto negativo.
- [Riesgo] `setAll(true)` pasará a incluir celdas de receso en "marcar todos disponibles" → Aceptable; el admin puede desmarcarlos individualmente. El comportamiento es más permisivo que antes.
- [Riesgo] Registros existentes en `horario` con `slot_id = 'mx'` o `'vx'` creados manualmente vía SQL → El motor ahora los reconocerá como slots válidos, sin efecto negativo.
- [Trade-off] El motor necesita el semestre del grupo en todos sus call sites — incrementa acoplamiento mínimo entre motor y datos de grupo, pero esto es correcto dado el dominio.

## Migration Plan

No se requieren cambios en el esquema SQL ni migración de datos. El cambio es backward-compatible: los nuevos keys de disponibilidad (`mx_0`, `r2a_1`, etc.) simplemente no existen en registros anteriores y se leen como `false` por la lógica existente de lookup.
