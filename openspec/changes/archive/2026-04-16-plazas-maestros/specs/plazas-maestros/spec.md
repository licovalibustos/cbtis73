## ADDED Requirements

### Requirement: El sistema gestiona plazas presupuestales del maestro
El sistema SHALL permitir registrar, editar y eliminar las plazas presupuestales de cada maestro. Cada plaza pertenece a un maestro (relación 1:N) y almacena: código de plaza, fecha de ingreso a la SEP, fecha de ingreso a la DGETI, condición de nombramiento (1=Base, 2=Interinato, 3=Otro) y turno (M=Matutino, V=Vespertino, A=Ambos). Los campos de fecha SHALL almacenarse como texto en formato YYYYMM.

#### Scenario: Agregar plaza a un maestro
- **WHEN** el admin captura los datos de una nueva plaza y confirma
- **THEN** el sistema SHALL persistir la plaza en `maestros_plazas` vinculada al maestro, y mostrarla en la lista de plazas del panel de detalle

#### Scenario: Editar plaza existente
- **WHEN** el admin modifica los campos de una plaza ya guardada y confirma
- **THEN** el sistema SHALL actualizar el registro en `maestros_plazas` y reflejar los cambios en la UI inmediatamente

#### Scenario: Eliminar plaza
- **WHEN** el admin solicita eliminar una plaza
- **THEN** el sistema SHALL eliminar el registro de `maestros_plazas` y removerla de la lista del panel de detalle

#### Scenario: Maestro sin plazas
- **WHEN** un maestro no tiene plazas registradas
- **THEN** el panel de detalle SHALL mostrar el estado vacío sin bloquear ninguna funcionalidad del sistema

### Requirement: Validación de formato YYYYMM en fechas de plaza
El sistema SHALL validar que los campos `fecha_ingreso_sep` y `fecha_ingreso_dgeti` tengan exactamente 6 dígitos numéricos (formato YYYYMM) antes de guardar.

#### Scenario: Fecha con formato válido
- **WHEN** el admin ingresa una fecha como `201303`
- **THEN** el sistema SHALL aceptar el valor y proceder con el guardado

#### Scenario: Fecha con formato inválido
- **WHEN** el admin ingresa una fecha con formato incorrecto (ej. `2013-03`, `abcdef`, o menos/más de 6 dígitos)
- **THEN** el sistema SHALL mostrar un mensaje de error y no guardar la plaza

### Requirement: Carga de plazas junto con datos del maestro
El sistema SHALL cargar las plazas de cada maestro desde `maestros_plazas` al mismo tiempo que carga los maestros, y almacenarlas en memoria en el arreglo `plazas` dentro del objeto del maestro (`TEACHERS[i].plazas`).

#### Scenario: Carga inicial con plazas existentes
- **WHEN** el sistema carga los maestros al iniciar
- **THEN** cada objeto maestro SHALL incluir su arreglo `plazas` con los datos de `maestros_plazas`

#### Scenario: Maestro sin registros en maestros_plazas
- **WHEN** el sistema carga un maestro que no tiene plazas
- **THEN** el objeto del maestro SHALL tener `plazas = []` (arreglo vacío, no null)
