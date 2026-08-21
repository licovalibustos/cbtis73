## Context

El export de horarios por grupo (`exportHorariosGrupoExcel` en `sistema_horarios_v1.html`) rellena templates `.xlsx` por turno y semestre usando coordenadas definidas en `getGroupTemplateConfig(turno, sem)`. Los grupos de 5° semestre tienen 10 materias, pero:

- `buildHorarioGrupoExcelModel` recorta las materias con `.slice(0,9)`.
- `buildHorarioGrupoTemplateCellMap` limpia y escribe exactamente 10 filas (`start..start+9`) en las tablas Materias y Abreviaturas.
- El usuario ya insertó un renglón dentro de la tabla de Materias de los templates M_5 y V_5, y otro antes del último renglón de la tabla de Abreviaturas. Esto corrió `abvStartRow` +1 (M_5: 39→40, V_5: 38→39); `materiaStartRow` no cambia porque la inserción fue dentro del bloque.

## Goals / Non-Goals

**Goals:**
- Que el export de grupos escriba hasta N materias, donde N viene de la configuración del template (`materiaRows`), no de un valor fijo.
- Corregir `abvStartRow` para M_5 y V_5 tras la edición manual de los templates.
- Dejar el mecanismo preparado para futuros templates con distinto número de renglones (solo tocar `getGroupTemplateConfig`).

**Non-Goals:**
- Anclaje dinámico por texto/etiquetas en el XML del template (opción más robusta pero mayor esfuerzo; se descarta por ahora).
- Cambiar el export de Horario Maestro (`Template_Horario_Maestro.xlsx`).
- Unificar los múltiples templates en uno solo.

## Decisions

1. **Extender `getGroupTemplateConfig` con campo `materiaRows`** en lugar de anclaje por etiquetas. Es la evolución natural del patrón existente (config declarativa por template), bajo riesgo y un solo lugar a mantener. El anclaje queda como mejora futura si aparecen más variantes.
2. **Quitar `.slice(0,9)` y usar `cfg.materiaRows`.** El modelo ya agrega y ordena las materias; el límite es responsabilidad del template, así que debe venir del config.
3. **Valores actualizados:** para 5° semestre, `materiaRows:10`; `abvStartRow` M_5 39→40 y V_5 38→39. Los demás templates conservan `materiaRows:9` y sus valores actuales.
4. **Los `clearRange` usan `cfg.materiaRows`** (`start .. start+materiaRows-1`) para limpiar exactamente las filas disponibles del template.

## Risks / Trade-offs

- [Coordenadas desalineadas si el template real difiere de lo asumido] → Verificar visualmente un export de prueba de 5° semestre (bordes de tabla Abreviaturas alineados).
- [Merges verticales rotos por la inserción manual en Excel] → Revisar el archivo generado; si hay merges rotos, corregirlos en el template.
- [`schedRows` sigue limitado a 8 franjas] → Fuera de alcance; la grilla de horario no cambió.
