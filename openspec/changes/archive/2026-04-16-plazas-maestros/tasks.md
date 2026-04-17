## 1. Base de datos (Supabase)

- [x] 1.1 Ejecutar `ALTER TABLE maestros ADD COLUMN IF NOT EXISTS grado text, egresado_de text, especialidad_acad text, departamento text` en Supabase SQL Editor
- [x] 1.2 Crear tabla `maestros_plazas` con columnas: `id uuid PK`, `maestro_id text FK→maestros(id) ON DELETE CASCADE`, `plaza text NOT NULL`, `fecha_ingreso_sep text`, `fecha_ingreso_dgeti text`, `condicion_nom smallint CHECK (1,2,3)`, `turno char(1) CHECK (M,V,A)`
- [x] 1.3 Habilitar RLS en `maestros_plazas` y crear políticas de lectura pública y escritura anon (equivalentes a las de `maestros`)

## 2. Carga de datos en memoria

- [x] 2.1 Extender el override async de `ensureTeachers` para hacer un segundo `fetch` a `maestros_plazas` y poblar `t.plazas = []` en cada objeto de `TEACHERS`
- [x] 2.2 Asegurarse de que los 4 campos nuevos de encabezado (`grado`, `egresado_de`, `especialidad_acad`, `departamento`) se lean del resultado del fetch existente de `maestros` y se almacenen en el objeto del maestro

## 3. Formulario de maestro — campos de encabezado

- [x] 3.1 Agregar 4 inputs al modal `modal-teacher` (dentro del form de maestro): `mte-grado`, `mte-egresado`, `mte-especialidad-acad`, `mte-departamento` — todos opcionales, text, uppercase
- [x] 3.2 Actualizar `saveTeacher()` para leer los 4 campos nuevos e incluirlos en el objeto upsert a `maestros`
- [x] 3.3 Actualizar `openTeacherModal(t)` para poblar los 4 inputs al editar un maestro existente
- [x] 3.4 Actualizar `resetTeacherModal()` para limpiar los 4 inputs al abrir el modal en modo "Nuevo"

## 4. Panel de detalle — encabezado

- [x] 4.1 Actualizar `renderMaestroDetail(id)` para mostrar los 4 campos del encabezado en el panel. Mostrar `—` si están vacíos

## 5. Sección de plazas — UI y CRUD

- [x] 5.1 Agregar sección "Plazas" en `renderMaestroDetail(id)` con la lista de plazas y botón "Agregar plaza". Chip de conteo con `tag t-green` si hay plazas, `tag t-gray` si no
- [x] 5.2 Crear modal (o formulario inline) `modal-plaza` con inputs: `plz-codigo` (plaza), `plz-sep` (fecha SEP YYYYMM), `plz-dgeti` (fecha DGETI YYYYMM), `plz-condicion` (select 1/2/3), `plz-turno` (select M/V/A)
- [x] 5.3 Implementar función `savePlaza()`: valida formato YYYYMM en fechas, hace upsert a `maestros_plazas`, actualiza `t.plazas` en memoria, re-renderiza la sección de plazas
- [x] 5.4 Implementar botón editar (✏ `btn-ghost btn-xs`) por cada plaza en la lista — abre el modal/formulario pre-poblado
- [x] 5.5 Implementar botón eliminar (🗑 `btn-ghost btn-xs`) por cada plaza — llama a `dbDel` y actualiza `t.plazas` en memoria

## 6. Validación y pruebas manuales

- [x] 6.1 Agregar maestro nuevo con todos los campos de encabezado → verificar que se guardan y se muestran en detalle
- [x] 6.2 Editar maestro existente → verificar que los campos de encabezado se pre-llenan y actualizan correctamente
- [x] 6.3 Agregar 2 plazas distintas a un maestro → verificar chip de conteo, lista y datos en Supabase
- [x] 6.4 Editar una plaza existente → verificar que los cambios persisten
- [x] 6.5 Eliminar una plaza → verificar que desaparece de la lista y de la BD
- [x] 6.6 Ingresar fecha con formato inválido (`2013-03`) → verificar que se muestra error y no se guarda
- [x] 6.7 Verificar que el flujo de asignaciones y motor de horarios funciona sin cambios con un maestro que tiene/no tiene plazas
