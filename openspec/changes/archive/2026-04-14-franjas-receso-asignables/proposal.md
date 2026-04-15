## Why

Los slots `mx` (9:50–10:40) y `vx` (16:15–17:00) están incorrectamente marcados como `blocked:true` en la definición de SLOTS, lo que impide al motor de asignación usarlos para grupos de 1°-2° semestre que sí tienen clases en esos horarios. Adicionalmente, los slots de receso (`r2a`, `r46a`, `r2b`, `r46b`) se renderizan como divisores no interactivos, por lo que los maestros no pueden marcar disponibilidad en esas franjas aunque el motor podría asignar clases que terminan o empiezan justo ahí.

## What Changes

- Remover `blocked:true` de `mx` y `vx`; agregar `forSem:[1,2]` a ambos
- Agregar `forSem:[3,4,5,6]` a `m4` y `v4` (actualmente sin restricción de semestre)
- Cambiar `assignable(turno)` a `assignable(turno, sem)` para filtrar por `forSem` cuando esté presente
- Agregar regla de exclusión mutua: un mismo maestro no puede tener `m4` y `mx` el mismo día (ni `v4` y `vx`), porque sus horarios se sobreponen
- Convertir slots de receso en celdas seleccionables (estilo ámbar) en las grillas de disponibilidad de `sistema_horarios_v1.html` y `maestro.html`
- `renderHorario()` debe mostrar `mx`/`vx` como slots normales para grupos de 1°-2°
- Sincronizar la misma definición de SLOTS en `maestro.html`

## Capabilities

### New Capabilities
- `franjas-receso-asignables`: Modelo correcto de slots de transición y receso — SLOTS con `forSem`, `assignable` con filtro de semestre, exclusión mutua `m4`/`mx` y `v4`/`vx`, celdas de receso seleccionables en grillas de disponibilidad

### Modified Capabilities
- `asignacion-maestros`: El motor de asignación debe usar `assignable(turno, sem)` y respetar la nueva regla de exclusión mutua entre slots solapados del mismo turno

## Impact

- `sistema_horarios_v1.html`: SLOTS definiton, `assignable()`, `renderDispGrid()`, `renderMvGrids()`, `renderHorario()`, `setAll()`, `isConflict()`/`detectConflicts()`
- `maestro.html`: SLOTS definition, `renderMvGrids()` (o equivalente)
- Tablas Supabase afectadas: `disponibilidad` (nuevas keys `r2a_d`, `r46a_d`, `r2b_d`, `r46b_d` serán guardadas), `horario` (nuevos `slot_id` posibles: `mx`, `vx`)
- Sin cambios en esquema SQL — solo cambios en lógica JS del frontend
