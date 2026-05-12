## Context

El motor actual de `runEngine` genera sugerencias por bloque y por hora suelta, pero puede mezclar candidatos distintos dentro de una misma materia del mismo grupo. Además, hoy las `maestro_preferencias` existen como dato persistente, pero no determinan de forma explícita la selección del motor. La dirección necesita una política más predecible: una materia por grupo debe tener un solo maestro, los preferidos deben priorizarse y debe existir una explicación visible cuando faltan horas.

## Goals / Non-Goals

**Goals:**
- Hacer que `runEngine` seleccione un solo maestro por combinación grupo + materia.
- Priorizar `asignaciones.maestro_id` y, opcionalmente, `maestro_preferencias` antes del reparto libre.
- Persistir una regla por maestro para limitar su participación a grupos objetivo.
- Exponer un diagnóstico post-simulación sin depender de la aprobación de horarios.

**Non-Goals:**
- Cambiar la estructura de `horario` o el flujo de aprobación.
- Implementar sustituciones automáticas entre maestros.
- Resolver laboratorio con reglas independientes de `maestro_lab_id`.

## Decisions

**D1 — Selección por materia, no por slot**

El motor evaluará candidatos por `grupo + materia` y elegirá un solo maestro antes de distribuir slots. Si el maestro elegido no cubre todas las horas, se propondrán solo las horas posibles y el resto quedará diagnosticado como faltante. Alternativa descartada: seguir el modelo actual por slot y bloquear mezcla al final; complica revertir propuestas parciales y hace opaca la causa real del faltante.

**D2 — Prioridad: fijo > preferido > libre**

El orden de selección será: `asignaciones.maestro_id`, luego maestro preferido por `maestro_preferencias` cuando el toggle del motor esté activo, y finalmente reparto libre por competencias. Alternativa descartada: que el preferido solo sume puntaje; no garantiza el comportamiento administrativo esperado.

**D3 — Materia no divisible entre dos maestros**

Una vez elegido el maestro para una materia, todos los bloques y horas sueltas propuestos para esa materia usarán únicamente ese maestro. Alternativa descartada: permitir fallback parcial a otro docente; contradice la regla operativa confirmada durante la exploración.

**D4 — Regla persistente `solo_grupos_objetivo` en `maestros`**

Se agregará un booleano en `maestros` para indicar que un docente solo puede ser candidato en grupos definidos por sus preferencias o en asignaciones fijas. Alternativa descartada: guardar esta regla en `localStorage`; produciría resultados distintos según navegador y usuario.

**D5 — Diagnóstico derivado de la simulación**

El diagnóstico se construirá con la misma corrida de `runEngine`, acumulando por materia: horas requeridas, horas propuestas, maestro elegido y causa principal de faltante (`fixed_teacher`, `preferred_teacher`, `freeze_rule`, `availability`, `conflict`, `capacity`, `no_teacher`). Alternativa descartada: recalcular en una segunda pasada; duplica lógica y eleva riesgo de inconsistencias.

## Risks / Trade-offs

- [Más materias con horas faltantes] → Mitigación: diagnóstico visible con causa principal y horas pendientes.
- [Cambio de esquema en `maestros`] → Mitigación: migración aditiva con default `false`.
- [Mayor complejidad en `runEngine`] → Mitigación: separar helpers para selección de maestro, filtros de congelamiento y consolidación de diagnóstico.
- [Preferencias ambiguas por grupo sin ciclo] → Mitigación: seguir usando `grupo_clave + plantilla_id` como regla administrativa, solo para priorización.

## Migration Plan

1. Agregar columna `solo_grupos_objetivo boolean not null default false` a `maestros`.
2. Actualizar loaders y save/edit de maestro para leer y persistir la nueva columna.
3. Refactorizar `runEngine` para elegir maestro por materia antes de asignar slots.
4. Agregar controles UI del motor y panel de diagnóstico.
5. Rollback: dejar de usar la columna y revertir migración; el motor vuelve a política libre por slot.

## Open Questions

- Ninguna pendiente para implementación inicial; la política de maestro único, parcial permitido y preferido sin reemplazo parcial ya quedó definida.