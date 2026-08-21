## Why

Los grupos de 5° semestre tienen 10 materias, pero el export de Excel por grupo (`exportHorariosGrupoExcel`) recorta las materias a 9 (`.slice(0,9)`) y escribe en coordenadas fijas de template diseñadas para 9 renglones. El usuario ya actualizó los templates `Template_Horarios_Grupos_Matutino_5.xlsx` y `Template_Horarios_Grupos_Vespertino_5.xlsx` agregando un renglón en la tabla de Materias y otro antes del último renglón de la tabla de Abreviaturas, pero el código sigue cortando en 9 y las coordenadas de la tabla de Abreviaturas quedaron desfasadas +1.

## What Changes

- Parametrizar el número de filas de materias por template en `getGroupTemplateConfig` (nuevo campo `materiaRows`), en lugar del `+9` fijo.
- Eliminar el `.slice(0,9)` duro en `buildHorarioGrupoExcelModel`, usando `cfg.materiaRows`.
- Actualizar `abvStartRow` para los templates de 5° semestre: M_5 39→40, V_5 38→39 (corridos por el renglón insertado en la tabla de Materias).
- Ajustar los `clearRange` de las tablas Materias y Abreviaturas para usar el contador parametrizado.

## Capabilities

### New Capabilities

(ninguna)

### Modified Capabilities

- `horario-maestro-excel`: el export de horarios por grupo debe soportar templates con más de 9 materias (10 en 5° semestre), leyendo el límite desde la configuración del template en lugar de un valor fijo.

## Impact

- `sistema_horarios_v1.html`: funciones `getGroupTemplateConfig`, `buildHorarioGrupoExcelModel`, `buildHorarioGrupoTemplateCellMap`.
- Templates: `Template_Horarios_Grupos_Matutino_5.xlsx`, `Template_Horarios_Grupos_Vespertino_5.xlsx` (ya actualizados por el usuario, sin cambios de código).
- Sin cambios de base de datos ni de API.
