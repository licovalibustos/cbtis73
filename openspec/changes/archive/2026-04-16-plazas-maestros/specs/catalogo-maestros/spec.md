## ADDED Requirements

### Requirement: El formulario de maestro captura datos del encabezado del expediente
El sistema SHALL permitir registrar y editar los 4 campos de encabezado del expediente laboral del maestro: grado máximo de estudios (`grado`), institución de egreso (`egresado_de`), especialidad académica (`especialidad_acad`) y departamento o academia (`departamento`). Todos los campos son opcionales; su ausencia no debe impedir guardar ni usar al maestro en el sistema de horarios.

#### Scenario: Guardar maestro con campos de encabezado
- **WHEN** el admin captura grado, egresado_de, especialidad_acad y departamento en el formulario
- **THEN** el sistema SHALL persistir los valores en las columnas correspondientes de `maestros` y mostrarlos en el panel de detalle

#### Scenario: Guardar maestro sin campos de encabezado
- **WHEN** el admin guarda un maestro dejando en blanco los 4 campos de encabezado
- **THEN** el sistema SHALL guardar el maestro con esos campos como NULL (o cadena vacía) sin error, y el flujo de asignaciones SHALL funcionar con normalidad

#### Scenario: Editar maestro existente que no tenía encabezado
- **WHEN** el admin abre a editar un maestro que fue creado antes de esta funcionalidad
- **THEN** el sistema SHALL mostrar los 4 campos del encabezado vacíos, listos para capturar

### Requirement: El panel de detalle del maestro muestra los datos del expediente
El sistema SHALL mostrar los 4 campos del encabezado y la lista de plazas en el panel de detalle del maestro (`maest-detail`), con controles para agregar, editar y eliminar plazas inline.

#### Scenario: Panel de detalle con datos completos
- **WHEN** el admin selecciona un maestro que tiene todos los campos de encabezado y plazas registradas
- **THEN** el panel SHALL mostrar: grado, egresado_de, especialidad_acad, departamento, y la lista de plazas con todos sus campos

#### Scenario: Panel de detalle con datos parciales
- **WHEN** el admin selecciona un maestro con solo algunos campos capturados
- **THEN** el panel SHALL mostrar los campos disponibles y marcar los vacíos de forma que no generen confusión (ej. guión o etiqueta "—")

#### Scenario: Chip de conteo de plazas en la lista de maestros
- **WHEN** se renderiza la lista de maestros
- **THEN** cada item SHALL mostrar el número de plazas del maestro con clase `tag t-green` si tiene plazas, `t-gray` si no tiene ninguna
