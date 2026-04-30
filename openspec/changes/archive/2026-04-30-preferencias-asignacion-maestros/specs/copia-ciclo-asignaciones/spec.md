## ADDED Requirements

### Requirement: Propagación de preferencias al crear ciclo nuevo
El sistema SHALL, al crear un nuevo ciclo escolar, poblar `asignaciones.maestro_id` para grupos de 1° semestre usando los registros de `maestro_preferencias` cuya `grupo_clave` coincida con la clave del grupo nuevo, cruzados con el catálogo del nuevo ciclo por `plantilla_id`. Para grupos de semestres 2°–6°, el sistema SHALL copiar los valores de `maestro_id` de las `asignaciones` del ciclo anterior cuya `grupo_id` corresponda al grupo predecesor (misma clave con semestre-1).

#### Scenario: Grupo 1° nuevo recibe maestro desde preferencias
- **WHEN** se crea un ciclo nuevo y existe el grupo "1AVS"
- **THEN** el sistema SHALL buscar en `maestro_preferencias` los registros con `grupo_clave = "1AVS"`, cruzarlos con `materias_catalogo` del nuevo ciclo por `plantilla_id`, y escribir `maestro_id` en cada `asignacion` correspondiente

#### Scenario: Grupo 2°–6° nuevo hereda maestro del ciclo anterior
- **WHEN** se crea un ciclo nuevo y existe el grupo "2AVS" cuyo predecesor en el ciclo anterior era "1AVS"
- **THEN** el sistema SHALL copiar el `maestro_id` de cada `asignacion` del grupo "1AVS" del ciclo anterior hacia la `asignacion` equivalente del grupo "2AVS" en el nuevo ciclo, emparejando por `plantilla_id`

#### Scenario: Preferencia sin materia en catálogo del nuevo ciclo
- **WHEN** al crear ciclo, una preferencia de maestro referencia un `plantilla_id` que no tiene correspondencia en `materias_catalogo` del nuevo ciclo
- **THEN** el sistema SHALL omitir esa preferencia silenciosamente; las demás preferencias del maestro SHALL procesarse con normalidad

#### Scenario: Grupo 1° sin preferencias configuradas
- **WHEN** se crea un ciclo nuevo y un grupo de 1° no tiene coincidencias en `maestro_preferencias`
- **THEN** las `asignaciones` de ese grupo se crean con `maestro_id = null`, igual que el comportamiento actual

#### Scenario: Confirmación al crear ciclo con propagación
- **WHEN** el admin inicia la creación de un nuevo ciclo
- **THEN** el sistema SHALL mostrar en el diálogo de confirmación que se copiarán asignaciones de grupos 2°–6° y se aplicarán preferencias para grupos de 1°
