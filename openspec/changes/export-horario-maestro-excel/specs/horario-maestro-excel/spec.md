## ADDED Requirements

### Requirement: Exportación de horario por maestro a Excel
El sistema SHALL permitir exportar el horario de un maestro activo a un archivo Excel `.xlsx` desde la vista de Horario Maestro.

#### Scenario: Exportación iniciada desde la vista de maestro
- **WHEN** el usuario selecciona un maestro con horario cargado
- **THEN** el sistema SHALL generar un archivo `.xlsx` descargable con ese horario

### Requirement: Conservación del formato institucional
El sistema SHALL usar una plantilla Excel base para conservar encabezados, merges, estilos, colores de receso y firmas del formato institucional.

#### Scenario: Plantilla preservada
- **WHEN** el usuario exporta el horario
- **THEN** el archivo resultante SHALL mantener la estructura visual de la plantilla original

### Requirement: Inclusión de datos del maestro y horario
El sistema SHALL escribir en el Excel los datos del maestro, su carga académica y la grilla de horario por turno, día y franja.

#### Scenario: Datos completos en el archivo
- **WHEN** el sistema genera el Excel
- **THEN** el archivo SHALL incluir el nombre del maestro, su información básica y sus bloques asignados en el ciclo activo

### Requirement: Exportación independiente de la impresión
El sistema SHALL mantener la impresión actual sin modificarla y SHALL ofrecer la exportación Excel como una acción separada.

#### Scenario: Impresión sin cambios
- **WHEN** el usuario usa la opción de imprimir
- **THEN** el sistema SHALL seguir mostrando la salida actual sin generar el Excel