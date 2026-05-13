## ADDED Requirements

### Requirement: Flag permite_multi_grupo en catálogo de materias
El sistema SHALL almacenar un campo `permite_multi_grupo` (booleano, default `false`) en la tabla `materias_catalogo`. Este campo indica que el mismo maestro puede impartir esa materia a varios grupos en el mismo slot/día sin que se considere conflicto.

#### Scenario: Materia nueva tiene permite_multi_grupo en false por defecto
- **WHEN** el admin crea una materia nueva en el catálogo
- **THEN** el campo `permite_multi_grupo` se guarda como `false` a menos que el admin lo active

#### Scenario: Admin activa el flag en una materia existente
- **WHEN** el admin abre la edición de una materia y activa el toggle "Multi-grupo"
- **THEN** el sistema guarda `permite_multi_grupo = true` en `materias_catalogo` para esa materia

#### Scenario: Flag se propaga al copiar ciclo
- **WHEN** el admin copia un ciclo escolar
- **THEN** las materias del catálogo nuevo copian el valor de `permite_multi_grupo` de las materias del ciclo origen

---

### Requirement: Lookup multiGrupoNames construido desde el catálogo
El sistema SHALL construir un `Set<string>` de nombres de materias multi-grupo (`multiGrupoNames[cicloId]`) inmediatamente después de cargar `catalogo[cicloId]` con `ensureCatalogo`. El Set SHALL invalidarse cuando el admin crea o edita una materia del catálogo.

#### Scenario: Set construido al cargar catálogo
- **WHEN** se llama `ensureCatalogo(cicloId)` y el catálogo no estaba en memoria
- **THEN** `multiGrupoNames[cicloId]` queda populado con los `nombre` de todas las materias donde `permite_multi_grupo = true`

#### Scenario: Set actualizado tras editar materia
- **WHEN** el admin guarda cambios en una materia del catálogo (crear, editar o eliminar)
- **THEN** `catalogo[cicloId]` y `multiGrupoNames[cicloId]` se invalidan (se borran) para forzar recarga en el próximo acceso

---

### Requirement: isConflict no reporta conflicto para materias multi-grupo
La función `isConflict(tid, slotId, day, exGroup, subjectName = null)` SHALL omitir como conflicto cualquier slot de otro grupo donde: (a) la materia de ese slot existente está en `multiGrupoNames[currentCicloId]`, Y (b) la materia entrante (`subjectName`) es la misma y también está en `multiGrupoNames`.

#### Scenario: Mismo maestro, mismo slot, misma materia multi-grupo en dos grupos
- **WHEN** el admin asigna al maestro T el slot L12:55 del lunes para SALUD EMS en el grupo 2BML, y ya existe una asignación de T en ese mismo slot para SALUD EMS en el grupo 2AMS
- **THEN** `isConflict` retorna `false` y no se muestra pill rojo

#### Scenario: Mismo maestro, mismo slot, materias distintas (una multi-grupo)
- **WHEN** el admin asigna al maestro T el slot L12:55 para MATEMATICAS en grupo 2BML, y ya existe asignación de T en ese slot para SALUD EMS en grupo 2AMS
- **THEN** `isConflict` retorna `true` (las materias son distintas)

#### Scenario: Mismo maestro, mismo slot, misma materia pero NO multi-grupo
- **WHEN** el admin asigna al maestro T el slot L12:55 para FISICA en grupo 2BML, y ya existe asignación de T en ese slot para FISICA en grupo 2AMS, pero FISICA no tiene `permite_multi_grupo = true`
- **THEN** `isConflict` retorna `true` (materia normal, sigue siendo conflicto)

---

### Requirement: detectConflicts excluye pares multi-grupo
La función `detectConflicts()` SHALL no reportar como conflicto un slot/maestro/día compartido por múltiples grupos cuando **todos** los grupos involucrados tienen la misma materia y dicha materia está en `multiGrupoNames[currentCicloId]`.

#### Scenario: Todos los grupos comparten misma materia multi-grupo
- **WHEN** los grupos 2AMS, 2BML y 2AML tienen al maestro T asignado en el slot L12:55 todos con SALUD EMS, y SALUD EMS tiene `permite_multi_grupo = true`
- **THEN** `detectConflicts()` no incluye a T en los resultados para ese slot

#### Scenario: Un grupo tiene materia distinta en el mismo slot
- **WHEN** los grupos 2AMS y 2BML tienen al maestro T en L12:55 con SALUD EMS, pero 2AML tiene a T en L12:55 con MATEMATICAS
- **THEN** `detectConflicts()` reporta el conflicto para T en ese slot (no todos son la misma materia multi-grupo)

---

### Requirement: Toggle Multi-grupo en UI del catálogo de materias
El sistema SHALL mostrar un control "Multi-grupo" (checkbox o toggle) en el formulario de edición de materias del catálogo. El control SHALL ser visible tanto al crear como al editar una materia.

#### Scenario: Toggle visible en formulario de nueva materia
- **WHEN** el admin abre el formulario para crear una nueva materia
- **THEN** el formulario incluye un toggle "Multi-grupo (varios grupos simultáneos)" en estado desactivado por defecto

#### Scenario: Toggle refleja valor guardado al editar materia
- **WHEN** el admin abre la edición de una materia que tiene `permite_multi_grupo = true`
- **THEN** el toggle aparece activado

#### Scenario: Guardar materia con toggle activo persiste el flag
- **WHEN** el admin activa el toggle y guarda la materia
- **THEN** `materias_catalogo.permite_multi_grupo` queda en `true` para esa materia
