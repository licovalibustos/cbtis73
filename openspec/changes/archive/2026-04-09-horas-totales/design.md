## Context

El modal `#modal-materia` actualmente expone "Horas/Aula" y "Horas Lab" como inputs independientes sin guía contextual. Para materias CFP existe una tabla institucional que define la distribución recomendada según el total de horas; sin ella, el admin debe conocer el desglose de memoria o consultarlo externamente. No hay cambio de esquema en DB — `materias_catalogo` ya almacena `hrs` y `hrs_lab` por separado.

## Goals / Non-Goals

**Goals:**
- Agregar campo "Horas Totales" visible solo para tipo CFP
- Auto-sugerir aula+lab desde lookup table al cambiar el total
- Permitir ajuste manual de aula/lab con validación de suma en tiempo real
- Bloquear guardado si suma ≠ total

**Non-Goals:**
- Cambios de esquema en `materias_catalogo`
- Afectar materias troncales u optativas
- Persistir el total en DB (es display-only)

## Decisions

**D1 — Total como campo display-only, no persiste en DB**
El total se puede recalcular en cualquier momento como `hrs + hrs_lab`. Agregarlo a DB crearía redundancia y riesgo de inconsistencia. Se calcula on-the-fly al abrir el modal.
- Alternativa descartada: columna `hrs_total` en `materias_catalogo` — innecesario, `hrs + hrs_lab` ya es el total.

**D2 — Lookup table como constante JS en el cliente**
La tabla institucional es estática y pequeña (9 filas). Definirla como objeto literal JS en el cliente es suficiente; no requiere tabla DB ni endpoint.
```js
const HRS_LOOKUP = {6:[4,2], 8:[5,3], 10:[6,4], 11:[7,4], 13:[8,5], 15:[9,6], 17:[10,7], 19:[11,8], 20:[12,8]};
```
- Alternativa descartada: tabla `horas_lookup` en Supabase — overhead innecesario para datos fijos.

**D3 — Fallback par/impar para totales fuera de tabla**
Si el total no está en la lookup, el sistema distribuye equitativamente: par → [T/2, T/2]; impar → [(T+1)/2, (T-1)/2]. Esto es mejor que bloquear o no sugerir nada.

**D4 — Validación live + bloqueo al guardar**
El hint naranja en tiempo real guía al admin sin ser bloqueante mientras escribe. El bloqueo al guardar es la barrera definitiva. Esta combinación es consistente con el patrón `matValidate()` ya existente.

**D5 — Campo `mm-total` controlado por `onMmTipoChange()`**
El campo se muestra/oculta junto con el bloque de especialidad CFP, reutilizando el mismo toggle. Al cambiar tipo a no-CFP, el campo desaparece y los inputs aula/lab vuelven a ser completamente libres.

## Risks / Trade-offs

- **[Risk] El admin edita `hrs` o `hrs_lab` directamente sin tocar `mm-total`** → el hint muestra la discrepancia en tiempo real y bloquea al guardar. No hay inconsistencia silenciosa.
- **[Risk] Materias CFP existentes con suma correcta pero total no en lookup** → al editar, el total se pre-llena como `hrs + hrs_lab`; si la suma ya cuadra, el admin puede guardar sin cambios.
- **[Trade-off] Total fuera de tabla no tiene referencia institucional** → se acepta; el fallback par/impar es una heurística razonable y el admin siempre puede ajustar.
