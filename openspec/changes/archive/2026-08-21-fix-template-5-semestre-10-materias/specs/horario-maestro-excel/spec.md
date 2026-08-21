## MODIFIED Requirements

### Requirement: Exportación de horario por maestro a Excel
El sistema SHALL permitir exportar el horario de un grupo activo a un archivo Excel `.xlsx` desde la vista de Horarios, usando la plantilla correspondiente al turno y semestre del grupo. El número máximo de materias escritas SHALL derivarse de la configuración del template (`materiaRows`) en lugar de un valor fijo, de modo que los templates con más renglones (p. ej. 5° semestre con 10 materias) se rellenen completamente.

#### Scenario: Exportación iniciada desde la vista de grupos
- **WHEN** el usuario exporta los horarios de un semestre y turno
- **THEN** el sistema SHALL generar un archivo `.xlsx` con una hoja por grupo, usando la plantilla correspondiente

#### Scenario: Grupo con 10 materias en 5° semestre
- **WHEN** un grupo de 5° semestre tiene 10 materias asignadas
- **THEN** el sistema SHALL escribir las 10 materias en la tabla de Materias y sus abreviaturas en la tabla de Abreviaturas, sin descartar ninguna

#### Scenario: Grupo con menos materias que filas disponibles
- **WHEN** un grupo tiene menos materias que las filas disponibles del template
- **THEN** el sistema SHALL dejar vacías las filas restantes sin desalinear las tablas
