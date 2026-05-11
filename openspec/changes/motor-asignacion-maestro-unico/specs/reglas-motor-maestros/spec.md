## ADDED Requirements

### Requirement: Regla persistente de grupos objetivo por maestro
El sistema SHALL permitir marcar a un maestro con una regla persistente para participar únicamente en sus grupos objetivo. Cuando esta regla esté activa, el maestro SHALL ser candidato solo para materias con `maestro_id` fijo a su favor o para preferencias de `maestro_preferencias` que coincidan con la combinación grupo + materia.

#### Scenario: Activar restricción de grupos objetivo
- **WHEN** el admin activa la opción de grupos objetivo en el detalle de un maestro
- **THEN** el sistema SHALL persistir la regla en Supabase y mostrarla en futuras cargas del maestro

#### Scenario: Maestro congelado queda fuera del reparto global
- **WHEN** el motor procesa una materia de un grupo que no coincide con una preferencia del maestro congelado ni con un `maestro_id` fijo para él
- **THEN** el maestro congelado SHALL quedar excluido de la lista de candidatos libres

#### Scenario: Maestro congelado sí participa en su grupo objetivo
- **WHEN** el motor procesa una materia cuyo grupo y plantilla coinciden con una preferencia del maestro congelado
- **THEN** el maestro congelado SHALL seguir siendo candidato válido para esa materia

#### Scenario: Regla desactivada restaura comportamiento normal
- **WHEN** el admin desactiva la regla de grupos objetivo para un maestro
- **THEN** el motor SHALL volver a considerar a ese maestro en el reparto global por competencias