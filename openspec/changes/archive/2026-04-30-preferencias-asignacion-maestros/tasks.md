## 1. Base de datos

- [x] 1.1 Crear tabla `maestro_preferencias` (`id` uuid PK, `maestro_id` text FK→maestros, `plantilla_id` uuid FK→materias_plantilla, `grupo_clave` text, UNIQUE(maestro_id, plantilla_id, grupo_clave))
- [x] 1.2 Agregar política RLS a `maestro_preferencias`: lectura y escritura para rol autenticado
- [x] 1.3 Verificar que el migration.sql corre sin errores en Supabase

## 2. Carga de datos en memoria

- [x] 2.1 Crear variable global `preferencias` (`{}` keyed por `maestro_id`) para cachear `maestro_preferencias`
- [x] 2.2 Crear función `ensurePreferencias(maestroId)`: carga lazy desde Supabase y cachea en `preferencias[maestroId]`
- [x] 2.3 Actualizar `ensureTeachers()` para cargar recuento de preferencias por maestro junto con plazas (o agregar campo `prefCount` al objeto maestro en memoria)

## 3. UI — Panel de detalle del maestro

- [x] 3.1 Agregar sección "Grupos preferidos" al renderizar `renderMaestroDetail()`, con llamada a `ensurePreferencias()` antes de pintar
- [x] 3.2 Renderizar lista de preferencias (materia + grupo_clave) con botón ✕ por fila
- [x] 3.3 Agregar botón "+ Agregar" que abre modal de nueva preferencia
- [x] 3.4 Crear modal de nueva preferencia: selector de materia (filtrado a competencias del maestro) + campo de texto grupo_clave
- [x] 3.5 Implementar `guardarPreferencia(maestroId)`: valida campos, llama `dbPost('maestro_preferencias', ...)`, actualiza cache y re-renderiza
- [x] 3.6 Implementar `eliminarPreferencia(id)`: llama `dbDelete('maestro_preferencias', id)`, actualiza cache y re-renderiza
- [x] 3.7 Agregar chip de conteo de preferencias en la lista de maestros (tag t-green / t-gray)

## 4. Motor de asignación

- [x] 4.1 En `runEngine()`, antes de llamar a `competentTeachers()`, verificar si `subj.teacherId` ya tiene valor
- [x] 4.2 Si `teacherId` ya tiene valor: construir lista de candidatos con solo ese maestro (array de 1 elemento); omitir llamada a `competentTeachers()`
- [x] 4.3 Si `teacherId` es null: comportamiento actual sin cambios
- [x] 4.4 Verificar que `findPairTeacher()` con un solo candidato emite `no_slot` correctamente cuando no hay disponibilidad, sin buscar alternativas

## 5. Lógica de creación de ciclo

- [x] 5.1 Localizar en `sistema_horarios_v1.html` la función o flujo que crea un nuevo ciclo
- [x] 5.2 Para grupos 2°–6°: después de crear las asignaciones vacías, buscar el grupo predecesor en el ciclo anterior por coincidencia de clave (sem-1) y copiar `maestro_id` de cada asignación emparejando por `plantilla_id`
- [x] 5.3 Para grupos 1°: después de crear las asignaciones vacías, cargar `maestro_preferencias` y escribir `maestro_id` en cada asignación cuyo `materia_catalogo.plantilla_id` coincida con la preferencia y cuyo grupo_clave coincida
- [x] 5.4 Actualizar el diálogo de confirmación de creación de ciclo para mencionar la propagación de asignaciones y preferencias

## 6. Validación y pruebas manuales

- [x] 6.1 Agregar preferencia a un maestro y verificar que aparece en la lista del panel de detalle
- [x] 6.2 Eliminar una preferencia y verificar que desaparece
- [x] 6.3 Ejecutar el motor con un grupo cuyas asignaciones ya tienen `maestro_id`: confirmar que las sugerencias solo proponen a ese maestro
- [x] 6.4 Ejecutar el motor con maestro fijo sin disponibilidad: confirmar que la sugerencia queda `no_slot` y no reasigna a otro maestro
- [x] 6.5 Crear un ciclo nuevo y verificar que los grupos 1° reciben `maestro_id` desde las preferencias
- [x] 6.6 Crear un ciclo nuevo y verificar que los grupos 2°–6° heredan `maestro_id` del ciclo anterior
- [x] 6.7 Verificar que grupos 1° sin preferencias configuradas siguen creando asignaciones con `maestro_id = null`
