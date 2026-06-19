## Context

La aplicación es una SPA de un solo archivo con Supabase REST y renderizado en memoria. La vista de maestro ya sabe cargar clases por `maestro_id`, `grupo_id`, `slot_id` y `dia`, así que la exportación Excel puede construirse como una capa de salida sobre esos datos sin cambiar el modelo relacional.

## Goals / Non-Goals

**Goals:**
- Exportar un `.xlsx` desde “Horario Maestro” con formato institucional.
- Reutilizar los datos actuales de maestro, grupos, horario y disponibilidad.
- Mantener el comportamiento actual de impresión sin afectar la navegación.

**Non-Goals:**
- No crear nuevas tablas ni triggers.
- No cambiar el motor de asignación ni la lógica de captura.
- No introducir un backend nuevo.

## Decisions

D1. Usar una plantilla `.xlsx` como base y JSZip para editar el contenido OOXML (worksheet/styles) sin reconstruir el libro. Alternativa descartada: construir un libro desde cero, porque sería más frágil para conservar merges, estilos y firmas.

D2. Mapear la salida desde un modelo intermedio en memoria por maestro, ciclo, turno y día. Alternativa descartada: leer directamente del DOM, porque la exportación debe ser independiente del estado visual.

D3. Mantener la exportación como acción explícita en la vista de maestro. Alternativa descartada: sobrecargar el botón de impresión actual, porque impresión y Excel son salidas distintas.

D4. No persistir datos nuevos en Supabase. La exportación sólo consume `ciclos`, `maestros`, `grupos`, `horario` y `disponibilidad`. Esto evita migraciones y reduce riesgo operativo.

## Migration Plan

1. Incrustar o cargar la plantilla Excel base en el frontend.
2. Añadir la acción de exportación en la vista de maestro.
3. Validar que el mapeo turno/franja reproduzca la grilla institucional.
4. Probar con un maestro de matutino y uno de vespertino.

Rollback: remover el botón y la lógica de exportación; no hay cambios de esquema que revertir.

## Risks / Trade-offs

- [Plantilla desalineada] → El mapeo de celdas puede no coincidir con el formato esperado; mitigación: validar con un ejemplo real antes de cerrar.
- [Peso del frontend] → Embutir la plantilla aumenta el tamaño del HTML; mitigación: usar sólo el template blanco necesario.
- [Compatibilidad del navegador] → La descarga de `.xlsx` depende de la compatibilidad de JSZip/Blob y del navegador; mitigación: probar en el entorno objetivo.

## Open Questions

- ¿La exportación debe incluir sólo clases aprobadas o también pendientes?
- ¿Las observaciones de disponibilidad se autollenan o se dejan vacías para captura manual?
- ¿Se necesita un nombre de archivo fijo o uno con nombre del maestro y ciclo?