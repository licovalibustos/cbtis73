## ADDED Requirements

### Requirement: Campo de horas totales para materias CFP
El sistema SHALL mostrar un campo "Horas Totales" únicamente cuando el tipo de materia es CFP, que permite al admin ingresar el total de horas y recibe una sugerencia automática de desglose en Horas/Aula y Horas Lab basada en la tabla institucional.

#### Scenario: Auto-sugerencia desde tabla institucional
- **WHEN** el admin ingresa un total de horas que existe en la tabla institucional (ej. 15)
- **THEN** el sistema rellena automáticamente Horas/Aula y Horas Lab con los valores correspondientes de la tabla (ej. aula=9, lab=6)

#### Scenario: Fallback para total fuera de tabla
- **WHEN** el admin ingresa un total que no existe en la tabla institucional (ej. 7)
- **THEN** el sistema aplica distribución por defecto: si el total es par aula=total/2 y lab=total/2; si es impar aula=(total+1)/2 y lab=(total-1)/2

#### Scenario: Validación live de suma
- **WHEN** el admin modifica manualmente Horas/Aula o Horas Lab
- **THEN** el sistema muestra en tiempo real un hint naranja si la suma de ambos campos no es igual al total especificado

#### Scenario: Bloqueo al guardar con suma incorrecta
- **WHEN** el admin intenta guardar una materia CFP cuya suma aula+lab no coincide con el total especificado
- **THEN** el sistema bloquea el guardado y muestra un mensaje indicando cuál debe ser la suma correcta

#### Scenario: Campo oculto para tipos no-CFP
- **WHEN** el admin selecciona tipo "troncal" u "optativa"
- **THEN** el campo Horas Totales no aparece y los campos Horas/Aula y Horas Lab funcionan de forma independiente sin validación de suma

#### Scenario: Al editar materia CFP existente
- **WHEN** el admin abre el modal de edición de una materia CFP existente
- **THEN** el campo Horas Totales se pre-llena con la suma de `hrs + hrs_lab` de la materia; los campos aula y lab muestran sus valores actuales y la validación de suma opera normalmente
