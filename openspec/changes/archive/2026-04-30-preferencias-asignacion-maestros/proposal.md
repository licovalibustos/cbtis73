## Why

Los coordinadores necesitan prefijar qué maestro imparte qué materia en qué grupo, porque los maestros tienen preferencias inamovibles que el sistema debe respetar. Actualmente el motor de asignación ignora estas preferencias y puede sugerir cualquier maestro competente, generando conflictos administrativos.

## What Changes

- Nueva tabla `maestro_preferencias` que almacena reglas permanentes: maestro × plantilla_id × grupo_clave (ej. "1AVS").
- Nueva sección "Grupos preferidos" en el panel de detalle del maestro, con UI para agregar/quitar preferencias limitadas a sus competencias.
- Lógica de creación de ciclo: al crear un ciclo nuevo, poblar `asignaciones` de grupos 1° desde `maestro_preferencias`; copiar `asignaciones` con `maestro_id` ya asignado de ciclos anteriores para grupos 2°–6°.
- Motor de asignación: si `asignaciones.maestro_id` ya tiene valor, tratar ese maestro como restricción dura (no buscar alternativas).

## Capabilities

### New Capabilities

- `preferencias-maestros`: Gestión de reglas permanentes maestro × materia × grupo. CRUD en panel de detalle del maestro; selector de materia limitado a las competencias del maestro.
- `copia-ciclo-asignaciones`: Lógica de inicialización de asignaciones al crear un ciclo nuevo: copia para 2°–6° y población desde preferencias para 1°.

### Modified Capabilities

- `asignacion-maestros`: El motor ahora respeta `maestro_id` preexistente en `asignaciones` como restricción dura, en lugar de ignorarlo.

## Impact

- **DB**: Nueva tabla `maestro_preferencias` (`maestro_id`, `plantilla_id`, `grupo_clave`).
- **`sistema_horarios_v1.html`**: Panel detalle maestro (sección nuevas), `runEngine` / `findPairTeacher`, lógica de creación de ciclo.
- **Supabase RLS**: Nueva tabla requiere políticas de acceso.
