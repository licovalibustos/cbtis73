## Requirements

### Requirement: Vinculación de grupos a materias del catálogo
El sistema SHALL mantener registros en `asignaciones` que vinculan cada materia del catálogo con los grupos que la reciben, como base para el motor de asignación automática.

#### Scenario: Ver grupos vinculados a una materia
- **WHEN** el admin selecciona una materia del catálogo
- **THEN** el sistema muestra una tabla con todos los grupos del semestre correspondiente marcados como "✓ Incluido"; los registros en `asignaciones` se crean automáticamente con `maestro_id = null`

#### Scenario: El panel de materias es informativo, no asigna maestros
- **WHEN** el admin navega a la vista Materias
- **THEN** el sistema muestra qué grupos tienen cada materia; la asignación de maestros se realiza exclusivamente en el módulo "Asignación Automática"

#### Scenario: Un maestro asignado a múltiples grupos en la misma materia
- **WHEN** el motor asigna a RAYMUNDO MUÑOZ como maestro de "Inglés I" en los grupos 1AVTC, 1BVTC, 1CVTC y 1DVTC
- **THEN** el sistema registra 4 filas en `asignaciones` con el mismo `maestro_id` y distintos `grupo_id`, y el motor de horarios considera estos conflictos al asignar slots

#### Scenario: Filtrar grupos por especialidad en materias CFP
- **WHEN** el admin selecciona una materia CFP de la especialidad "L" (Laboratorio Clínico)
- **THEN** el sistema solo muestra los grupos cuyo campo `especialidad` es "L" (ej: 3AML, 3BML, 3AVL, 3BVL)

#### Scenario: Optativas — agregar/quitar grupos manualmente
- **WHEN** el admin agrega un grupo a una materia optativa
- **THEN** se crea un registro en `asignaciones` para ese par materia×grupo; se puede quitar con el botón ✕

#### Scenario: Vista de grupos sigue mostrando sus materias
- **WHEN** el admin navega al detalle de un grupo
- **THEN** el sistema muestra las materias asignadas a ese grupo (consultando `asignaciones` + `materias_catalogo`), con el maestro asignado por el motor a cada una

---

### Requirement: Motor de horarios usa asignaciones
El sistema SHALL leer el semestre del grupo al construir la lista de slots candidatos, invocando `assignable(turno, sem)` donde `sem` es el semestre del grupo objetivo. El motor SHALL generar sugerencias de **bloque** (dos franjas consecutivas del mismo día con el mismo maestro) como unidad primaria. Cuando no sea posible armar un bloque, el motor SHALL degradar a sugerencias de hora suelta. El motor SHALL continuar aplicando la regla de exclusión mutua entre los pares `(m4, mx)` y `(v4, vx)`. Para cada combinación grupo + materia, el motor SHALL elegir un solo maestro y SHALL usar ese mismo maestro en todas las sugerencias de la materia; MUST NOT repartir la materia entre dos maestros. Si `asignaciones.maestro_id` ya tiene valor para una asignación, el motor SHALL tratarlo como restricción dura: usará únicamente ese maestro, propondrá las horas que alcance a cubrir y dejará faltantes si es necesario; MUST NOT reasignar las horas restantes a otro maestro.

#### Scenario: Motor genera sugerencias para grupo de 1°
- **WHEN** se ejecuta el motor de asignación de slots para un grupo de 1° semestre matutino
- **THEN** el motor incluye `mx` como slot candidato y excluye `m4` para ese grupo

#### Scenario: Motor genera sugerencias para grupo de 4°
- **WHEN** se ejecuta el motor de asignación de slots para un grupo de 4° semestre matutino
- **THEN** el motor incluye `m4` como slot candidato y excluye `mx` para ese grupo

#### Scenario: Motor respeta exclusión mutua en bloques
- **WHEN** el maestro T05 ya tiene asignación en `m4` el lunes y el motor evalúa un bloque con slot candidato `mx` para T05 en otro grupo de 1°
- **THEN** el motor descarta ese bloque para T05 el lunes

#### Scenario: Motor usa un solo maestro para toda la materia
- **WHEN** el motor procesa una materia de 8 horas para un grupo y encuentra un maestro candidato para esa materia
- **THEN** todas las sugerencias generadas para esa materia usan el mismo `teacherId`

#### Scenario: Motor con maestro fijo propone parcial sin reemplazo
- **WHEN** el motor procesa una asignación con `maestro_id = T03` y T03 solo puede cubrir 6 de 8 horas
- **THEN** el motor propone únicamente 6 horas con T03, deja 2 horas faltantes y MUST NOT asignarlas a otro maestro

#### Scenario: Motor con preferido propone parcial sin repartir
- **WHEN** la opción de priorizar maestro preferido está activa y el maestro preferido solo puede cubrir parte de la materia
- **THEN** el motor usa solo a ese maestro preferido para la materia, propone las horas posibles y deja faltantes sin introducir un segundo maestro

#### Scenario: Motor sin fijo ni preferido elige un solo maestro
- **WHEN** la materia no tiene `maestro_id` fijo ni preferido aplicable
- **THEN** el motor selecciona un único maestro competente para esa materia y propone únicamente horas con ese maestro

#### Scenario: Motor respeta exclusión mutua (caso inverso)
- **WHEN** el maestro T05 ya tiene asignación en `mx` el martes y el motor evalúa slots para un grupo de 4° con T05
- **THEN** el motor descarta `m4` el martes para T05

#### Scenario: Motor usa asignaciones (comportamiento existente)
- **WHEN** se ejecuta el motor de asignación de slots para un grupo
- **THEN** el motor lee las materias y maestros desde `asignaciones` vinculadas al grupo, en lugar de la tabla `materias`

#### Scenario: Motor respeta maestro_id fijo — genera slots solo para ese maestro
- **WHEN** el motor procesa una asignación cuyo `maestro_id` ya tiene valor (ej. T03)
- **THEN** el motor SHALL usar T03 como único candidato, sin llamar a `competentTeachers()` para esa asignación

#### Scenario: Motor respeta maestro_id fijo — no reasigna aunque no haya slots
- **WHEN** el motor procesa una asignación con `maestro_id = T03` y T03 no tiene slots disponibles en ningún día
- **THEN** el motor SHALL emitir una sugerencia con `status = "no_slot"` manteniendo `teacherId = T03`; NO SHALL asignar a otro maestro

#### Scenario: Motor sin maestro_id — comportamiento actual
- **WHEN** el motor procesa una asignación cuyo `maestro_id` es null
- **THEN** el motor SHALL buscar candidatos mediante `competentTeachers(plantilla_id)` y seleccionar por disponibilidad y carga, igual que el comportamiento previo

#### Scenario: Sugerencia de bloque - aprobación escribe 2 celdas
- **WHEN** el admin aprueba una sugerencia de bloque (`slotB` presente)
- **THEN** el sistema SHALL escribir dos entradas en `schedule[cicloId][grupoId]` con la misma materia y el mismo maestro

#### Scenario: Sugerencia de bloque - UI muestra rango horario
- **WHEN** se renderiza la lista de sugerencias y una sugerencia tiene `slotB`
- **THEN** el sistema SHALL mostrar el rango completo (ej. "7:00–8:40") en lugar de solo la hora de inicio del primer slot

---

### Requirement: Competencias de maestros vinculadas a plantillas globales
El sistema SHALL almacenar las competencias de cada maestro como referencias a `materias_plantilla` (por `plantilla_id`) en lugar de strings de texto libre, garantizando que el match con el catálogo sea exacto y no se rompa ante correcciones de nombre.

#### Scenario: Agregar competencia desde selector
- **WHEN** el admin abre el modal de competencias de un maestro y escribe en el campo de búsqueda
- **THEN** el sistema muestra chips filtrables con los registros de `materias_plantilla` que coinciden; el admin selecciona uno y se guarda `{ maestro_id, plantilla_id }` en `competencias`

#### Scenario: Intentar agregar una materia que no existe en el catálogo
- **WHEN** el admin escribe un nombre que no corresponde a ningún registro en `materias_plantilla` y presiona guardar
- **THEN** el sistema muestra un mensaje de error "Materia no encontrada. Agrégala primero en el catálogo." y no crea el registro; para agregar esa materia, el admin debe ir al catálogo primero

#### Scenario: Motor encuentra maestros competentes por plantilla_id
- **WHEN** el motor busca maestros para una materia del catálogo con `plantilla_id = X`
- **THEN** el sistema retorna todos los maestros cuya tabla `competencias` contiene un registro con `plantilla_id = X`, sin comparación de strings

#### Scenario: Corrección de nombre no rompe competencias
- **WHEN** el admin renombra la plantilla "MATEMATICAS I" a "MATEMÁTICAS I"
- **THEN** las competencias de todos los maestros que referenciaban esa plantilla siguen válidas porque el vínculo es por `plantilla_id`, no por nombre
