## Why

El motor de asignación coloca **una hora por día** distribuida en hasta 5 días. La práctica pedagógica del plantel requiere que cada materia se imparta en **bloques de 2 horas consecutivas**, concentrando la presencia del maestro en 2-3 días por semana en lugar de fragmentarla diariamente.

## What Changes

- El motor genera **sugerencias de bloque** (2 franjas consecutivas del mismo día) en lugar de sugerencias de franja individual
- Cada bloque asegura el **mismo maestro en ambas horas**
- Si no existe par disponible para un día, el motor degrada a **1 hora suelta** (fallback)
- La UI de sugerencias muestra el **rango horario completo** del bloque (ej. "7:00–8:40")
- Aprobar una sugerencia escribe **2 celdas al schedule** (una por franja)

## Capabilities

### New Capabilities
- `motor-bloques`: Lógica del motor que itera días buscando pares de slots consecutivos libres con el mismo maestro disponible en ambas franjas

### Modified Capabilities
- `asignacion-maestros`: El comportamiento del motor cambia — las sugerencias ahora son de bloque (slotA + slotB) en lugar de franja individual

## Impact

- `sistema_horarios_v1.html`: función `runEngine()`, shape del objeto `suggestions[]`, funciones `approveSug()`, `approveAll()`, `renderSugList()`, `selSug()` modal
- `schedule` storage: sin cambios — un bloque aprobado es simplemente 2 celdas normales
- `renderHorario()`, `isConflict()`, `isUnavail()`: sin cambios
