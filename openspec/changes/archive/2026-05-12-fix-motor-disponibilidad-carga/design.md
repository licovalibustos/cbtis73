## Context

El motor `runEngine` en `sistema_horarios_v1.html` tiene tres puntos de falla relacionados con la fase de precarga y las reglas de elegibilidad de candidatos:

1. `availability` se carga lazy por maestro (solo cuando el admin visita su página). Si el admin no abrió la página de disponibilidad de un maestro, `availability[tid]` es `undefined` y el check `av === 'unavail'` nunca dispara — el slot se trata como `neutral`.

2. En `pickTeacherForSubject`, el path `cause='preferred'` hace `return` inmediato con el maestro preferido sin verificar si tiene `solo_grupos_objetivo=true` y si realmente tiene preferencia para ese grupo específico. Resultado: maestros congelados pueden aparecer en grupos que no les corresponden.

3. El límite de `hrs_carga` en `findPairTeacher` y Phase 2 bloquea a maestros con preferencias fijas aunque el usuario haya configurado esos grupos explícitamente. La intención del usuario es que el maestro cubra todos sus grupos preferidos sin importar si se pasa de su carga nominal.

## Goals / Non-Goals

**Goals:**
- `runEngine` precarga disponibilidad de todos los maestros en scope antes de iterar.
- `pickTeacherForSubject` valida `solo_grupos_objetivo` incluso en el path `preferred`.
- Maestros con `solo_grupos_objetivo=true` y `cause='preferred'` ignoran el tope de `hrs_carga`.

**Non-Goals:**
- No cambiar la lógica de bloques ni distribución de días.
- No cambiar comportamiento para maestros sin `solo_grupos_objetivo`.
- No modificar esquema de BD ni añadir columnas.

## Decisions

**D1 — Precarga de disponibilidad en `runEngine`**

Después del loop de preferencias, agregar un loop idéntico con `await ensureDisponibilidad(t.id)` para todos los maestros en `TEACHERS`. Esto garantiza que `availability[tid][currentCicloId]` existe antes de que el motor evalúe cualquier slot.

_Alternativa descartada_: cargar solo para maestros competentes en cada materia — más eficiente pero complejo de coordinar con el scope del motor; la lista de TEACHERS es pequeña (~88) así que el costo de cargar todos es negligible.

**D2 — Validación de `solo_grupos_objetivo` en path `preferred`**

En `pickTeacherForSubject`, después de obtener `pref` de `preferredTeacherFor`, añadir la verificación:
```
if (pref.solo_grupos_objetivo) {
  const hasPref = (preferencias[pref.id]||[]).some(
    p => p.plantilla_id === subj.plantilla_id && p.grupo_clave === g.clave
  );
  if (!hasPref) pref = null; // cae a free selection
}
```

_Alternativa descartada_: mover la validación a `preferredTeacherFor` — evita el cambio en `pickTeacherForSubject`, pero `preferredTeacherFor` no recibe el contexto del grupo actual de forma que distinga el caso congelado del no congelado.

**D3 — Bypass de `hrs_carga` para maestros preferidos fijos**

`pickTeacherForSubject` devuelve `{teacher, cause}`. Propagar `cause` hasta `findPairTeacher` y Phase 2 añadiendo un parámetro `ignoreCapacity: boolean`. Cuando `cause === 'preferred' && teacher.solo_grupos_objetivo`, pasar `ignoreCapacity=true`.

En `findPairTeacher` y Phase 2, reemplazar:
```
if(usedHrs + 2 > cand.hrs_carga + 1) continue;
```
por:
```
if(!ignoreCapacity && usedHrs + 2 > cand.hrs_carga + 1) continue;
```

_Alternativa descartada_: usar `hrs_carga = Infinity` temporalmente en el objeto — muta el objeto global y puede producir efectos colaterales en otras partes que leen `hrs_carga`.

## Risks / Trade-offs

- [Riesgo] Precarga de disponibilidad agrega N requests al inicio de `runEngine` (uno por maestro).
  → Mitigación: `ensureDisponibilidad` ya implementa el patrón cache-first; si los datos ya estaban en memoria no hace request. En la práctica solo hay requests la primera vez por sesión.

- [Riesgo] Maestros con `ignoreCapacity=true` pueden terminar con carga muy superior a su nominal, generando horarios inviables administrativamente.
  → Aceptado: es intención explícita del usuario al activar `solo_grupos_objetivo` y configurar las preferencias. La UI ya muestra las horas asignadas por maestro.

- [Riesgo] Si `subj.plantilla_id` es `null`, la validación D2 compara `null === null` para todas las materias sin plantilla, pudiendo dar falsos positivos.
  → Mitigación: añadir guard `if(!subj.plantilla_id) → skip preferred path` en `pickTeacherForSubject`.
