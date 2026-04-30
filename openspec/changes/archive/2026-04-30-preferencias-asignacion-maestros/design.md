## Context

El motor de asignación (`runEngine`) actualmente elige maestros por competencias y carga horaria disponible, ignorando cualquier preferencia administrativa preexistente. En la práctica, la dirección ya sabe qué maestro da qué materia en qué grupo, y cambiarlos genera conflictos. Se necesita un mecanismo para codificar esas preferencias como restricciones duras que el motor respete.

Las `asignaciones` ya tienen columna `maestro_id` nullable — el motor puede leerla. Lo que falta es: (1) una tabla que persista las preferencias permanentes fuera del ciclo, (2) UI para gestionarlas, y (3) lógica para propagarlas al crear ciclos nuevos.

## Goals / Non-Goals

**Goals:**
- Permitir al admin definir reglas permanentes: maestro → plantilla_id × grupo_clave.
- Propagar esas reglas a `asignaciones.maestro_id` al crear un ciclo nuevo (grupos 1°) o copiarlas desde el ciclo anterior (grupos 2°–6°).
- El motor respeta `maestro_id` ya asignado como restricción dura: solo genera slots para ese maestro, no busca alternativas.
- UI en panel de detalle del maestro para gestionar sus preferencias.

**Non-Goals:**
- Manejo de sustituciones o ausencias del maestro preferido.
- Validación de carga horaria contra las preferencias al guardarlas.
- Propagación automática retroactiva a ciclos ya existentes.
- Preferencias para maestro de laboratorio (`maestro_lab_id`).

## Decisions

**D1 — Tabla nueva `maestro_preferencias` en lugar de reutilizar `asignaciones`**

`asignaciones` es por ciclo; las preferencias son permanentes. Mezclar los dos conceptos en la misma tabla obligaría a duplicar registros cada ciclo o a distinguir por una columna tipo `es_preferencia`. Una tabla separada mantiene el modelo limpio.

*Alternativa descartada:* campo `preferencia_permanente boolean` en `asignaciones` — contamina la tabla principal y complica los queries del motor.

**D2 — `grupo_clave` como texto (no FK a `grupos.id`)**

Las preferencias son permanentes pero los grupos son por ciclo. No existe un grupo "1AVS" permanente — cada ciclo crea uno nuevo con distinto uuid. Guardar la clave como texto (ej. "1AVS") permite matchear contra `grupos.clave` en cualquier ciclo futuro sin FK rota.

*Alternativa descartada:* FK a `grupos.id` — rompería en cada ciclo nuevo.

**D3 — Motor trata `maestro_id` preexistente como restricción dura**

Si `asignaciones.maestro_id` ya tiene valor cuando `runEngine` procesa esa asignación, el motor no llama a `competentTeachers()` sino que usa directamente ese maestro como único candidato. Si no tiene slots disponibles, la sugerencia queda marcada `no_slot` pero **no** se reasigna a otro maestro.

*Alternativa descartada:* tratar como preferencia blanda (intentar primero pero buscar sustituto) — el cliente fue explícito: el cambio genera quejas, debe ser duro.

**D4 — Propagación al crear ciclo en `crearCiclo()`**

Al crear un ciclo:
1. Grupos 2°–6°: para cada grupo nuevo que sea continuación de un grupo del ciclo anterior (misma clave de raíz, semestre+1), copiar las `asignaciones` con `maestro_id` del ciclo anterior hacia el nuevo.
2. Grupos 1°: para cada grupo 1° nuevo, buscar en `maestro_preferencias` los registros cuyo `grupo_clave` coincida con la clave del grupo nuevo y cuyo `plantilla_id` tenga una `materia_catalogo` en el nuevo ciclo; escribir `maestro_id` en la `asignacion` correspondiente.

*Alternativa descartada:* propagar solo al guardar preferencia — requiere que el admin regenere datos ya existentes; más propenso a inconsistencias.

**D5 — Selector de materia en UI limitado a competencias del maestro**

Al agregar una preferencia desde el panel del maestro, el selector solo muestra plantillas donde el maestro ya tiene competencia registrada. Evita asignaciones incoherentes sin necesidad de validación server-side adicional.

## Risks / Trade-offs

- **Clave de grupo como texto es frágil a renombrados** → Si el admin cambia la clave de un grupo (ej. "1AVS" a "1AV"), las preferencias quedan huérfanas. Mitigación: advertir en la UI al editar la clave de un grupo si hay preferencias vinculadas (fuera del scope de este change, registrado como deuda).

- **Ciclos anteriores no se actualizan retroactivamente** → Las preferencias solo aplican a ciclos nuevos. Los ciclos existentes con `maestro_id = null` siguen usando el motor libre. Es el comportamiento esperado.

- **Motor con maestro duro puede generar más sugerencias `no_slot`** → Si el maestro preferido no tiene disponibilidad, la asignación queda sin slot. El admin deberá resolverlo manualmente. Es preferible a un cambio silencioso de maestro.

- **`tmpHrs` del motor puede sobrepasar carga del maestro fijo** → Si un maestro tiene muchas preferencias duras, el motor puede superar su `hrs_carga`. Mitigación: mostrar advertencia en la sugerencia (igual que hoy con otros candidatos).

## Migration Plan

1. Ejecutar `migration.sql` en Supabase: crea tabla `maestro_preferencias` con RLS.
2. Sin migración de datos necesaria — la tabla empieza vacía; el admin captura las preferencias.
3. El cambio en `runEngine` es aditivo: si `maestro_id` es null, comportamiento idéntico al actual.
4. Rollback: revertir `migration.sql` (DROP TABLE) y deshacer cambios en JS.
