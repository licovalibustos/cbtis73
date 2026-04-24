## 1. Motor — lógica de bloques en `runEngine()`

- [x] 1.1 Extraer helper `findPair(slots, groupId, day, sched)` que dado el array de slots asignables y un día, devuelve el primer par `[slotA, slotB]` donde ambas celdas estén libres para el grupo
- [x] 1.2 Reescribir el loop principal de `runEngine()` para iterar día → par de slots en lugar de slot → día
- [x] 1.3 Implementar selección del maestro para el bloque: candidato debe pasar `isConflict` e `isUnavail` en `slotA` Y `slotB`; el score usa el mínimo de disponibilidad de ambas franjas
- [x] 1.4 Implementar fallback: cuando `hrsLeft > 0` y no quedan pares disponibles, continúa con el loop original (hora suelta) para colocar las horas restantes

## 2. Shape de sugerencia — campo `slotB`

- [x] 2.1 Cambiar `slotId` → `slotA` en el objeto `suggestion`; añadir `slotB` (string | null); asegurarse que código existente que lee `s.slotId` se actualice a `s.slotA`
- [x] 2.2 Actualizar `approveSug()` para que cuando `s.slotB` exista, escriba dos celdas en `schedule[currentCicloId][s.groupId]`: `slotA_day` y `slotB_day` con la misma materia y maestro
- [x] 2.3 Actualizar `approveAll()` con la misma lógica de doble escritura

## 3. UI de sugerencias

- [x] 3.1 En `renderSugList()`, mostrar el rango horario completo cuando `s.slotB` existe: buscar el label de `slotB` en `allSlots()` y mostrar `"${slotA.lbl.split('–')[0]}–${slotB.lbl.split('–')[1]}"`
- [x] 3.2 En el modal de detalle (`selSug()`), mostrar las dos franjas del bloque en la sección "Horario" cuando aplique

## 4. Validación manual

- [x] 4.1 Correr el motor con un ciclo real — verificar en la lista de sugerencias que las materias de 4+ horas generan sugerencias de bloque (rango horario visible, ej. "7:00–8:40")
- [x] 4.2 Aprobar un bloque y verificar en `renderHorario()` del grupo que aparecen 2 celdas contiguas con la misma materia y maestro
- [x] 4.3 Aprobar "Aprobar todo" y verificar que no quedan horas dobles por bloque no escrito
- [x] 4.4 Verificar fallback: forzar un escenario con poco espacio disponible y confirmar que las horas restantes se colocan como suelta sin errores en consola
- [x] 4.5 Verificar que los conflictos de maestro siguen funcionando correctamente al aprobar bloques
