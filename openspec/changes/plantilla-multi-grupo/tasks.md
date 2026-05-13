## 1. Base de datos

- [ ] 1.1 Ejecutar migración en Supabase: `ALTER TABLE materias_catalogo ADD COLUMN IF NOT EXISTS permite_multi_grupo BOOLEAN NOT NULL DEFAULT false`

## 2. Lógica JS — lookup multiGrupoNames

- [ ] 2.1 Declarar `const multiGrupoNames = {}` junto a los demás globales (cerca de `let catalogo = {}`)
- [ ] 2.2 En `ensureCatalogo`, tras popular `catalogo[cicloId]`, construir `multiGrupoNames[cicloId] = new Set(catalogo[cicloId].filter(m => m.permite_multi_grupo).map(m => m.nombre))`
- [ ] 2.3 En el handler de guardar materia (crear y editar), invalidar `catalogo[cicloId]` y `multiGrupoNames[cicloId]` (borrar ambas claves) para forzar recarga en el próximo acceso

## 3. Lógica JS — isConflict

- [ ] 3.1 Añadir parámetro opcional `subjectName = null` a la firma de `isConflict`
- [ ] 3.2 En el loop interno de `isConflict`, antes de `return true`, agregar: si `subjectName` está en `multiGrupoNames[currentCicloId]` y `cells[key].subjectName === subjectName` y también está en el Set → `continue`
- [ ] 3.3 Actualizar callers de UI que conocen el `subjectName`: `cellCheck()`, `cellSave()` base, `cellSave` override (async) — pasar el `subjectName` como 5.º argumento
- [ ] 3.4 Actualizar el caller de drag-drop (`dropCell`) — pasar `sched[fromKey]?.subjectName` como 5.º argumento a `isConflict`

## 4. Lógica JS — detectConflicts

- [ ] 4.1 Modificar el acumulador de `detectConflicts` para que cada entrada del map almacene `{ gid, subjectName }` en lugar de solo `gid`
- [ ] 4.2 En el filtro de conflictos, agregar exención: si todas las entradas del slot comparten el mismo `subjectName` y ese nombre está en `multiGrupoNames[currentCicloId]` → excluir del resultado
- [ ] 4.3 Asegurar que el resultado siga exponiendo `gs` como array de `gid` (string) para no romper callers de `detectConflicts`

## 5. UI — Toggle Multi-grupo en catálogo de materias

- [ ] 5.1 Añadir un `<label>` con checkbox al formulario de edición/creación de materia: `<label><input type="checkbox" id="mcatalog-multigrup"> Multi-grupo (varios grupos simultáneos)</label>`
- [ ] 5.2 Al abrir el formulario en modo edición, establecer `checked` según el valor de `permite_multi_grupo` de la materia
- [ ] 5.3 Al crear materia, leer el checkbox e incluir `permite_multi_grupo` en el payload del `dbPost`
- [ ] 5.4 Al editar materia, leer el checkbox e incluir `permite_multi_grupo` en el payload del `dbPatch`

## 6. Copia de ciclo

- [ ] 6.1 En la función de copia de ciclo (`copyCiclo` o equivalente), verificar que el `dbPost` de `materias_catalogo` ya incluye el campo `permite_multi_grupo` (debe copiarse junto con los demás campos); actualizar si fuera necesario

## 7. Validación manual

- [ ] 7.1 Crear SALUD EMS en el catálogo con `permite_multi_grupo = true` y verificar que el toggle se guarda correctamente
- [ ] 7.2 Asignar el mismo maestro al mismo slot con SALUD EMS en 3 grupos distintos y confirmar que no aparecen pills rojos
- [ ] 7.3 Asignar el mismo maestro al mismo slot con MATEMATICAS (sin flag) en 2 grupos y confirmar que el pill rojo sí aparece
- [ ] 7.4 Desactivar el toggle en SALUD EMS, reconstruir el Set y confirmar que los pills rojos vuelven a aparecer para esa materia
- [ ] 7.5 Copiar ciclo y verificar que las materias del nuevo ciclo conservan el valor de `permite_multi_grupo`
