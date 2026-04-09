## 1. Constante y lógica de lookup

- [x] 1.1 Definir constante `HRS_LOOKUP` en JS: `{6:[4,2], 8:[5,3], 10:[6,4], 11:[7,4], 13:[8,5], 15:[9,6], 17:[10,7], 19:[11,8], 20:[12,8]}`
- [x] 1.2 Implementar función `hrsLookup(total)` que retorna `[aula, lab]` desde la tabla o aplica fallback par/impar

## 2. HTML — modal-materia

- [x] 2.1 Agregar input `#mm-total` (type=number, min=1) con label "Horas Totales" en el modal, envuelto en `#mm-total-wrap` para mostrarlo/ocultarlo
- [x] 2.2 Agregar `oninput="onMmTotalChange()"` al input `#mm-total`
- [x] 2.3 Agregar `id="mm-hrs-hint"` debajo del bloque frow de aula/lab para mostrar el hint de validación de suma
- [x] 2.4 Agregar `oninput="onMmHrsChange()"` a los inputs `#mm-hrs` y `#mm-lab`

## 3. JS — control de visibilidad y sugerencia

- [x] 3.1 Modificar `onMmTipoChange()` para mostrar `#mm-total-wrap` solo cuando tipo=cfp y ocultarlo en troncal/optativa; al ocultar, limpiar `#mm-hrs-hint`
- [x] 3.2 Implementar `onMmTotalChange()`: lee `#mm-total`, llama `hrsLookup(total)`, rellena `#mm-hrs` y `#mm-lab`, luego llama `onMmHrsChange()` para actualizar hint
- [x] 3.3 Implementar `onMmHrsChange()`: calcula suma aula+lab, compara con `#mm-total`; si difieren muestra hint naranja "La suma debe ser {total}"; si son iguales limpia el hint

## 4. JS — apertura del modal

- [x] 4.1 En `openMateriaCatModal()` (nueva materia): limpiar `#mm-total`, ocultar/mostrar `#mm-total-wrap` según tipo inicial, limpiar `#mm-hrs-hint`
- [x] 4.2 En `openMateriaCatModal()` (editar materia CFP existente): pre-llenar `#mm-total` con `mc.hrs + mc.hrs_lab` y mostrar `#mm-total-wrap`

## 5. JS — validación al guardar

- [x] 5.1 En `saveMateriasCatalogo()`: si tipo=cfp, validar que `hrs + hrs_lab === parseInt(mm-total.value)`; si no coinciden, mostrar toast de error y hacer return antes de guardar

## 6. Validación y pruebas manuales

- [x] 6.1 Crear materia CFP con total=15 → verificar que sugiere aula=9, lab=6 y guarda correctamente
- [x] 6.2 Crear materia CFP con total=7 (fuera de tabla, impar) → verificar fallback aula=4, lab=3
- [x] 6.3 Crear materia CFP con total=12 (par, fuera de tabla) → verificar fallback aula=6, lab=6
- [x] 6.4 Modificar aula manualmente dejando suma incorrecta → verificar hint naranja y bloqueo al guardar
- [x] 6.5 Editar materia CFP existente → verificar que total se pre-llena con hrs+hrs_lab
- [x] 6.6 Crear materia troncal → verificar que campo Horas Totales no aparece y aula/lab funcionan sin restricciones
