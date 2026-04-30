## ADDED Requirements

### Requirement: Gestión de preferencias permanentes de maestro
El sistema SHALL permitir al admin definir reglas permanentes que vinculan un maestro con una materia (por `plantilla_id`) y una clave de grupo (ej. "1AVS"). Estas reglas se almacenan en la tabla `maestro_preferencias` independientemente de cualquier ciclo escolar. El selector de materia SHALL limitarse a las competencias ya registradas del maestro.

#### Scenario: Agregar preferencia desde panel de detalle
- **WHEN** el admin presiona "+ Agregar" en la sección "Grupos preferidos" del panel de detalle de un maestro
- **THEN** el sistema SHALL mostrar un modal con selector de materia (filtrado a competencias del maestro) y campo de grupo_clave; al confirmar, SHALL persistir el registro en `maestro_preferencias` y mostrarlo en la lista

#### Scenario: Selector de materia solo muestra competencias del maestro
- **WHEN** el admin abre el modal de nueva preferencia para un maestro
- **THEN** el sistema SHALL mostrar únicamente las plantillas que el maestro tiene en su tabla `competencias`, no el catálogo completo

#### Scenario: Eliminar preferencia
- **WHEN** el admin presiona el botón ✕ junto a una preferencia en la lista
- **THEN** el sistema SHALL eliminar el registro de `maestro_preferencias` y removerlo de la lista inmediatamente

#### Scenario: Maestro sin preferencias
- **WHEN** un maestro no tiene registros en `maestro_preferencias`
- **THEN** el panel SHALL mostrar la sección "Grupos preferidos" vacía con estado vacío; ninguna funcionalidad existente SHALL verse afectada

#### Scenario: Chip de conteo en lista de maestros
- **WHEN** se renderiza la lista de maestros
- **THEN** cada maestro SHALL mostrar el número de preferencias registradas con clase `tag t-green` si tiene al menos una, `t-gray` si no tiene ninguna
