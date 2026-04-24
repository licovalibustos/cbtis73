## Why

Al agregar una materia CFP, el administrador debe ingresar Horas/Aula y Horas Lab por separado, sin guía de cuántas le corresponden. Existe una tabla institucional que define el desglose recomendado según el total de horas de la materia, pero el sistema no la expone. Esto genera errores de captura y requiere que el admin consulte la tabla externamente.

## What Changes

- Nuevo campo "Horas Totales" visible únicamente cuando `tipo = cfp` en el modal de materia
- Al ingresar el total, el sistema sugiere automáticamente Horas/Aula y Horas Lab desde la tabla institucional
- Si el total no está en la tabla, se aplica fallback (par: mitad y mitad; impar: aula = mitad+1, lab = resto)
- Aula y Lab siguen siendo editables para permitir ajustes manuales
- Validación en tiempo real: hint naranja si la suma aula+lab ≠ total; guardar bloqueado con suma incorrecta
- Al editar una materia CFP existente, el total se pre-llena con `hrs + hrs_lab`

## Capabilities

### New Capabilities
- `horas-totales-cfp`: Campo de horas totales con lookup table, sugerencia automática de desglose aula/lab y validación de suma para materias CFP

### Modified Capabilities
- `catalogo-materias`: El modal de materia cambia su UX de captura de horas para tipo CFP; los campos `hrs` y `hrs_lab` en `materias_catalogo` no cambian de esquema

## Impact

- `sistema_horarios_v1.html`: modal `#modal-materia`, función `onMmTipoChange()`, `openMateriaCatModal()`, `saveMateriasCatalogo()` y su DB override
- `materias_catalogo`: sin cambios de esquema (se siguen guardando `hrs` y `hrs_lab`)
