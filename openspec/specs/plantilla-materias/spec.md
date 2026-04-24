## Requirements

### Requirement: Catálogo global de plantillas de materias
El sistema SHALL mantener una tabla `materias_plantilla` con los nombres canónicos de todas las materias, independiente de ciclos, que sirve como fuente de verdad para competencias y catálogos por ciclo.

#### Scenario: Crear nueva plantilla
- **WHEN** el admin escribe un nombre nuevo al agregar una competencia o una materia al catálogo
- **THEN** el sistema crea un registro en `materias_plantilla` con ese nombre en mayúsculas y lo reutiliza para cualquier ciclo o competencia futura

#### Scenario: Nombre duplicado no crea plantilla duplicada
- **WHEN** el admin intenta crear una plantilla con un nombre que ya existe (misma cadena normalizada en mayúsculas)
- **THEN** el sistema reutiliza la plantilla existente sin crear un duplicado

#### Scenario: Renombrar una plantilla propaga el cambio
- **WHEN** el admin corrige el nombre de una plantilla (ej: "MATEMATICAS I" → "MATEMÁTICAS I")
- **THEN** el nuevo nombre aparece automáticamente en el catálogo de todos los ciclos que referencian esa plantilla y en las competencias de todos los maestros vinculados

#### Scenario: No se puede eliminar una plantilla en uso
- **WHEN** el admin intenta eliminar una plantilla que tiene competencias o instancias en `materias_catalogo` asociadas
- **THEN** el sistema rechaza la operación y muestra cuántas competencias e instancias de catálogo dependen de ella
