## 1. Configuración de templates

- [x] 1.1 Agregar campo `materiaRows` a cada rama de `getGroupTemplateConfig`: 10 para 5° semestre (M_5 y V_5), 9 para el resto
- [x] 1.2 Actualizar `abvStartRow` en `getGroupTemplateConfig`: M_5 39→40, V_5 38→39

## 2. Modelo de datos

- [x] 2.1 En `buildHorarioGrupoExcelModel`, reemplazar `.slice(0,9)` por el límite desde `cfg.materiaRows` (obtener config del grupo)

## 3. Escritura del template

- [x] 3.1 En `buildHorarioGrupoTemplateCellMap`, usar `cfg.materiaRows` en los `clearRange` de las tablas Materias y Abreviaturas (reemplazar `+9` fijo)

## 4. Verificación

- [x] 4.1 Exportar horarios de 5° semestre (matutino y vespertino) con un grupo de 10 materias y confirmar que las 10 aparecen en ambas tablas
- [x] 4.2 Verificar visualmente que la tabla de Abreviaturas queda alineada con los bordes del template (sin filas desfasadas ni merges rotos)
- [x] 4.3 Exportar un semestre de 9 materias (1° o 3°) y confirmar que no hay regresiones
