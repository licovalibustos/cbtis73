# Spec: Horario Maestro Excel

## Purpose

Permite exportar el horario de un maestro activo a un archivo Excel `.xlsx` conservando el formato institucional, incluyendo datos del maestro y su grilla de horario por turno, día y franja, como acción independiente a la impresión.

## Requirements

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

---

### Requirement: Conservación del formato institucional
El sistema SHALL usar una plantilla Excel base para conservar encabezados, merges, estilos, colores de receso y firmas del formato institucional.

#### Scenario: Plantilla preservada
- **WHEN** el usuario exporta el horario
- **THEN** el archivo resultante SHALL mantener la estructura visual de la plantilla original

---

### Requirement: Inclusión de datos del maestro y horario
El sistema SHALL escribir en el Excel los datos del maestro, su carga académica y la grilla de horario por turno, día y franja.

#### Scenario: Datos completos en el archivo
- **WHEN** el sistema genera el Excel
- **THEN** el archivo SHALL incluir el nombre del maestro, su información básica y sus bloques asignados en el ciclo activo

---

### Requirement: Exportación independiente de la impresión
El sistema SHALL mantener la impresión actual sin modificarla y SHALL ofrecer la exportación Excel como una acción separada.

#### Scenario: Impresión sin cambios
- **WHEN** el usuario usa la opción de imprimir
- **THEN** el sistema SHALL seguir mostrando la salida actual sin generar el Excel
