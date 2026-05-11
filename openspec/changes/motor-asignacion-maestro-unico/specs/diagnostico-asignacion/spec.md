## ADDED Requirements

### Requirement: Diagnóstico post-simulación por materia
El sistema SHALL mostrar un diagnóstico post-simulación por cada combinación grupo + materia evaluada por el motor. El diagnóstico SHALL incluir horas requeridas, horas propuestas, horas faltantes, el maestro elegido para la materia y la causa principal del faltante cuando exista.

#### Scenario: Materia completa sin faltantes
- **WHEN** el motor termina de simular una materia y logra cubrir todas sus horas con un solo maestro
- **THEN** el diagnóstico muestra la materia como completa, con el maestro elegido y cero horas faltantes

#### Scenario: Faltante por disponibilidad o conflicto
- **WHEN** el maestro elegido no puede cubrir todas las horas por disponibilidad o conflicto horario
- **THEN** el diagnóstico SHALL mostrar horas faltantes y la causa principal correspondiente

#### Scenario: Faltante por carga del maestro
- **WHEN** el maestro elegido alcanza su `hrs_carga` antes de cubrir todas las horas de la materia
- **THEN** el diagnóstico SHALL mostrar el faltante con causa principal de carga

#### Scenario: Faltante por regla de grupos objetivo
- **WHEN** un maestro competente queda fuera de la evaluación por su regla de grupos objetivo y no hay otro maestro válido
- **THEN** el diagnóstico SHALL reportar la causa principal como restricción de grupos objetivo

#### Scenario: Sin maestro competente
- **WHEN** ninguna competencia coincide con la materia evaluada
- **THEN** el diagnóstico SHALL mostrar la materia como sin maestro competente y con todas las horas faltantes