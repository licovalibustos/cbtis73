## Why

El motor actual puede repartir una misma materia de un grupo entre dos maestros, ignorar la prioridad administrativa de un maestro preferido y usar maestros competentes fuera de sus grupos objetivo. Esto produce propuestas sorprendentes, horas incompletas sin explicación clara y retrabajo manual al aprobar sugerencias.

## What Changes

- Cambiar el motor para que cada combinación grupo + materia se proponga con un solo maestro, aunque queden horas faltantes.
- Priorizar al maestro fijo de `asignaciones.maestro_id` y, opcionalmente, al maestro preferido por `maestro_preferencias` antes del reparto global.
- Agregar una regla persistente por maestro para limitarlo a sus grupos objetivo cuando así se configure.
- Mostrar un diagnóstico post-simulación que explique faltantes por carga, disponibilidad, conflicto, falta de preferido/fijo, congelamiento o falta de competencia.
- Mantener `Estricto` como opción separada de disponibilidad; no cambia la política de maestro único.

## Goals

- Hacer predecible el resultado del motor para dirección y control escolar.
- Evitar que una materia quede repartida entre dos docentes.
- Explicar por qué faltan horas antes de aprobar propuestas.

## Non-Goals

- Cambiar la captura de horario aprobada en `horario`.
- Resolver sustituciones automáticas o ausencias temporales.
- Rediseñar la UI completa de asignación; solo se agregan controles y diagnóstico.

## Capabilities

### New Capabilities
- `diagnostico-asignacion`: diagnóstico post-simulación por grupo y materia con causas de faltantes y maestro elegido.
- `reglas-motor-maestros`: reglas persistentes de motor por maestro para limitar asignaciones a grupos objetivo.

### Modified Capabilities
- `asignacion-maestros`: el motor pasa a política de maestro único por materia, prioriza preferidos y reporta faltantes sin repartir horas entre dos maestros.
- `preferencias-maestros`: las preferencias dejan de ser solo informativas y pueden influir en el orden de selección del motor.

## Impact

- Código afectado: `sistema_horarios_v1.html` en controles de Asignación, `runEngine`, render de sugerencias, detalle de maestro y diagnóstico.
- Tablas afectadas: `asignaciones`, `maestro_preferencias`, `maestros`; posible migración para persistir la regla de grupos objetivo.
- Sistemas afectados: simulación del motor, experiencia de aprobación y administración de maestros.