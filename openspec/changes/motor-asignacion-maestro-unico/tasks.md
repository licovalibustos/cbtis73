## 1. Migración y persistencia

- [x] 1.1 Crear migración para agregar `solo_grupos_objetivo boolean not null default false` a `maestros`
- [x] 1.2 Actualizar los loaders de maestros para leer la nueva columna desde Supabase
- [x] 1.3 Actualizar guardar/editar maestro para persistir la regla de grupos objetivo

## 2. Selección de maestro por materia

- [x] 2.1 Refactorizar `runEngine` para elegir un solo maestro por combinación grupo + materia antes de proponer slots
- [x] 2.2 Implementar el orden de prioridad `maestro_id` fijo > preferido > reparto libre
- [x] 2.3 Impedir que una materia quede repartida entre dos maestros en la misma simulación
- [x] 2.4 Permitir propuesta parcial con un solo maestro y registrar horas faltantes sin reemplazo parcial

## 3. Reglas del motor por preferencias y grupos objetivo

- [x] 3.1 Agregar helper para detectar si existe maestro preferido por `grupo_clave + plantilla_id`
- [x] 3.2 Agregar toggle de motor para respetar maestro preferido antes del reparto libre
- [x] 3.3 Excluir del reparto global a maestros con `solo_grupos_objetivo = true` cuando el grupo no sea objetivo
- [x] 3.4 Permitir que un maestro congelado sí participe en sus grupos preferidos o en asignaciones fijas

## 4. UI de asignación y diagnóstico

- [x] 4.1 Agregar controles de UI para `Estricto` y `Respetar maestro preferido` sin mezclar responsabilidades
- [x] 4.2 Agregar control en detalle de maestro para activar/desactivar `solo_grupos_objetivo`
- [x] 4.3 Construir panel de diagnóstico post-simulación por grupo + materia con horas requeridas, propuestas, faltantes y causa principal
- [x] 4.4 Mostrar en sugerencias y estadísticas cuando una materia quedó parcial con un solo maestro

## 5. Validación y limpieza

- [x] 5.1 Validar que el motor nunca reparta una materia entre dos maestros en una misma corrida
- [x] 5.2 Validar escenarios con maestro fijo, preferido, congelado y sin maestro competente
- [x] 5.3 Verificar que el diagnóstico coincida con la simulación y que la UI no rompa badges ni filtros de ciclo
- [x] 5.4 Revisar toasts, textos y helpers temporales; limpiar código muerto o duplicado relacionado con el motor