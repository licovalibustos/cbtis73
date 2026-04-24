## MODIFIED Requirements

### Requirement: Catálogo de materias por ciclo y semestre
El sistema SHALL permitir definir un catálogo de materias agrupado por ciclo escolar y semestre, donde cada materia existe una sola vez independientemente de cuántos grupos la impartan. Cada materia del catálogo SHALL referenciar una `materias_plantilla` que provee el nombre canónico.

#### Scenario: Crear materia troncal
- **WHEN** el admin crea una materia con tipo "troncal" en el semestre 1
- **THEN** el sistema busca o crea el registro correspondiente en `materias_plantilla`, registra la materia en `materias_catalogo` con `plantilla_id` y `especialidad = null`, y la deja disponible para asignarse a cualquier grupo de ese semestre

#### Scenario: Crear materia CFP con sub-módulos
- **WHEN** el admin crea una materia de tipo "cfp" para la especialidad "P" (Programación)
- **THEN** el sistema busca o crea la plantilla, registra la materia con `plantilla_id` y la especialidad correspondiente; solo es visible en grupos de esa especialidad; el admin debe especificar el total de horas para recibir sugerencia de desglose aula/lab

#### Scenario: Crear materia con horas de laboratorio
- **WHEN** el admin especifica Horas Totales = 15 al crear una materia CFP
- **THEN** el sistema sugiere `hrs = 9` y `hrs_lab = 6` desde la tabla institucional; el admin puede ajustarlos siempre que la suma siga siendo 15; el sistema registra `hrs` y `hrs_lab` en `materias_catalogo`

#### Scenario: Las materias troncales aplican a todos los grupos del semestre
- **WHEN** se crean materias troncales para el semestre 3
- **THEN** el sistema muestra esas materias para todos los grupos de 3er semestre al gestionar asignaciones, sin importar la especialidad del grupo

#### Scenario: Copia de catálogo al crear nuevo ciclo
- **WHEN** el admin crea un nuevo ciclo escolar y selecciona "Copiar de ciclo anterior"
- **THEN** el sistema copia el catálogo de `materias_catalogo` del ciclo origen al nuevo ciclo incluyendo los `plantilla_id`, con `asignaciones` vacías (sin maestros)

#### Scenario: Nombre se elige desde plantillas al crear materia
- **WHEN** el admin abre el modal para crear o editar una materia del catálogo
- **THEN** el campo nombre es un input de texto libre; al escribir, el sistema valida en tiempo real si el nombre ya existe en el catálogo del ciclo actual y muestra un aviso inline bloqueando el guardado si hay duplicado; al guardar, el sistema busca automáticamente el registro correspondiente en `materias_plantilla` y lo crea si no existe, sin intervención del usuario
