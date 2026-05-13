## Why

El motor de asignación tiene tres bugs que producen resultados incorrectos: ignora disponibilidad marcada como NO disponible (porque no precarga los datos antes de correr), asigna maestros con `solo_grupos_objetivo` a grupos que no tienen en sus preferencias, y bloquea horas de grupos preferidos cuando el maestro supera su `hrs_carga` aunque el usuario haya configurado explícitamente esos grupos.

## What Changes

- **Precarga de disponibilidad en `runEngine`**: antes de iterar grupos, cargar `ensureDisponibilidad` para todos los maestros en scope, igual que ya se hace para preferencias.
- **Fix bypass de `solo_grupos_objetivo` en `pickTeacherForSubject`**: cuando `cause='preferred'`, verificar que el maestro elegido realmente tiene preferencia explícita para ese grupo antes de retornar; si tiene `solo_grupos_objetivo=true` y no hay preferencia para ese grupo, continuar a free selection filtrado.
- **Bypass de `hrs_carga` para maestros con preferencias fijas**: en `findPairTeacher` y Phase 2, cuando `cause='preferred'` y el maestro tiene `solo_grupos_objetivo=true`, omitir el check de capacidad para que cubra todos los grupos que el usuario le asignó aunque se pase de su carga nominal.

## Capabilities

### New Capabilities
- ninguna

### Modified Capabilities
- `motor-bloques`: cambia la fase de precarga del motor y las reglas de elegibilidad de candidatos (disponibilidad estricta, filtro `solo_grupos_objetivo`, bypass de carga para preferidos).

## Goals
- El motor nunca propone un slot en horario marcado como "No disponible" cuando el modo Estricto está activo.
- Un maestro con `solo_grupos_objetivo=true` nunca aparece en grupos que no tiene en sus preferencias.
- Un maestro con `solo_grupos_objetivo=true` y preferencias explícitas cubre todas las horas de esos grupos aunque supere `hrs_carga`.

## Non-Goals
- No cambiar la lógica de bloques consecutivos ni la distribución por días.
- No cambiar el comportamiento para maestros sin `solo_grupos_objetivo`.
- No modificar el esquema de BD.

## Impact

- `sistema_horarios_v1.html`: función `runEngine`, `findPairTeacher`, `pickTeacherForSubject` y Phase 2 de hora suelta.
- Tablas afectadas: `disponibilidad` (lectura), `maestro_preferencias` (lectura).
