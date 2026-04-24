## 1. Base de datos — Migration

- [x] 1.1 Ejecutar en Supabase SQL editor: crear tabla `materias_plantilla` (`id uuid PK`, `nombre text UNIQUE NOT NULL`)
- [x] 1.2 Poblar `materias_plantilla` desde nombres únicos de `materias_catalogo` (`INSERT INTO materias_plantilla SELECT DISTINCT UPPER(TRIM(nombre)) FROM materias_catalogo`)
- [x] 1.3 Agregar columna `plantilla_id uuid REFERENCES materias_plantilla(id)` a `materias_catalogo` y hacer UPDATE para mapear por nombre normalizado
- [x] 1.4 Verificar que `SELECT COUNT(*) FROM materias_catalogo WHERE plantilla_id IS NULL` = 0
- [x] 1.5 Agregar columna `plantilla_id uuid REFERENCES materias_plantilla(id)` a `competencias` y hacer UPDATE mapeando `UPPER(TRIM(materia))` → `materias_plantilla.id`
- [x] 1.6 Verificar que `SELECT COUNT(*) FROM competencias WHERE plantilla_id IS NULL` = 0
- [x] 1.7 Hacer `ALTER TABLE competencias ALTER COLUMN plantilla_id SET NOT NULL; DROP COLUMN materia`

## 2. JS — Loader y estructura de datos en memoria

- [x] 2.1 Agregar variable global `let plantillas = []` (array de `{id, nombre}` ordenado por nombre)
- [x] 2.2 Implementar `async function ensurePlantillas()` — carga `GET /materias_plantilla?order=nombre.asc` y cachea en `plantillas`; cortocircuito si ya cargado
- [x] 2.3 Llamar `ensurePlantillas()` en `init()` junto a `ensureCompetencias()`
- [x] 2.4 Actualizar `ensureCompetencias()` — el loader llena `competencias[maestro_id]` como `Set<uuid>` (leyendo `plantilla_id` en lugar de `materia`)
- [x] 2.5 Actualizar `competentTeachers(plantillaId)` — recibe uuid, compara contra `competencias[t.id].has(plantillaId)` en lugar de string

## 3. JS — Motor de asignación

- [x] 3.1 Actualizar `runEngine`: al buscar maestros competentes, pasar `m.plantilla_id` (de `materias_catalogo`) a `competentTeachers()` en lugar del nombre string
- [x] 3.2 Verificar que `ensureCatalogo` carga `plantilla_id` en cada materia del catálogo (agregar al `select=` del `dbGet` si no está)

## 4. JS — Guardar y eliminar competencias

- [x] 4.1 Actualizar override `saveComp`: buscar/crear plantilla en `materias_plantilla`, luego `dbPost('competencias', { maestro_id, plantilla_id })`
- [x] 4.2 Actualizar override `delComp`: el DELETE usa `plantilla_id=eq.${id}` en lugar de `materia=eq.${nombre}`
- [x] 4.3 Actualizar `competencias[tid]` en memoria al agregar/eliminar: guardar `plantilla_id` (uuid) en el Set, no el nombre

## 5. UI — Modal de competencias (picker)

- [x] 5.1 Reemplazar `<input type="text">` en modal-comp por input de búsqueda + lista desplegable filtrable desde `plantillas[]`
- [x] 5.2 Actualizar `compSuggest()` — filtra `plantillas` por texto ingresado; chips muestran el nombre pero al seleccionar guardan el `id`
- [x] 5.3 Agregar lógica "crear nueva plantilla": si el texto escrito no existe en `plantillas`, mostrar opción "+ Crear '[nombre]'" que hace `POST /materias_plantilla` antes de guardar la competencia
- [x] 5.4 Mostrar nombre de la plantilla en los chips de competencias del detalle del maestro (lookup `plantillas.find(p=>p.id===...)?.nombre`)

## 6. UI — Modal de catálogo de materias (picker de nombre)

- [x] 6.1 En modal de crear/editar materia del catálogo, reemplazar input de nombre libre por picker filtrable desde `plantillas[]`
- [x] 6.2 Agregar lógica "crear nueva plantilla" igual que en modal de competencias
- [x] 6.3 Actualizar `saveMateriasCatalogo`: al guardar, incluir `plantilla_id` en el POST/PATCH a `materias_catalogo`

## 7. Validación y limpieza

- [x] 7.1 Probar: crear nueva plantilla desde modal de competencias → aparece en `materias_plantilla`, competencia guarda uuid
- [x] 7.2 Probar: el motor sugiere maestro para una materia → match por `plantilla_id`, no por string
- [x] 7.3 Probar: renombrar una plantilla en Supabase dashboard → el nombre actualizado aparece en el detalle del maestro y en el catálogo al recargar
- [x] 7.4 Probar: agregar competencia con nombre que ya existe → reutiliza plantilla, no crea duplicado
- [x] 7.5 Probar: crear materia en catálogo → picker muestra plantillas existentes, al seleccionar se guarda `plantilla_id`
- [x] 7.6 Verificar que competencias previas (migradas) siguen mostrándose correctamente en el detalle del maestro
