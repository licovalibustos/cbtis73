## ADDED Requirements

### Requirement: Catálogo de materias por ciclo y semestre
El sistema SHALL permitir definir un catálogo de materias agrupado por ciclo escolar y semestre, donde cada materia existe una sola vez independientemente de cuántos grupos la impartan.

#### Scenario: Crear materia troncal
- **WHEN** el admin crea una materia con tipo "troncal" en el semestre 1
- **THEN** la materia queda registrada en `materias_catalogo` con `especialidad = null` y disponible para asignarse a cualquier grupo de ese semestre

#### Scenario: Crear materia CFP con sub-módulos
- **WHEN** el admin crea una materia de tipo "cfp" para la especialidad "P" (Programación)
- **THEN** la materia queda registrada con la especialidad correspondiente y solo es visible en grupos de esa especialidad

#### Scenario: Crear materia con horas de laboratorio
- **WHEN** el admin especifica `hrs = 2` y `hrs_lab = 6` al crear una materia CFP
- **THEN** el sistema registra ambos valores y los muestra como `(2/6)` en la interfaz

#### Scenario: Las materias troncales aplican a todos los grupos del semestre
- **WHEN** se crean materias troncales para el semestre 3
- **THEN** el sistema muestra esas materias para todos los grupos de 3er semestre al gestionar asignaciones, sin importar la especialidad del grupo

#### Scenario: Copia de catálogo al crear nuevo ciclo
- **WHEN** el admin crea un nuevo ciclo escolar y selecciona "Copiar de ciclo anterior"
- **THEN** el sistema copia el catálogo de `materias_catalogo` del ciclo origen al nuevo ciclo, con `asignaciones` vacías (sin maestros)
