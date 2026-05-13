## 1. Precarga de disponibilidad en runEngine

- [x] 1.1 En `runEngine`, después del loop `for(const t of TEACHERS) await ensurePreferencias(t.id)`, agregar un loop idéntico: `showLoading('Cargando disponibilidad…'); for(const t of TEACHERS) await ensureDisponibilidad(t.id);`

## 2. Fix solo_grupos_objetivo en pickTeacherForSubject

- [x] 2.1 En `pickTeacherForSubject`, antes del `return {teacher:pref,cause:'preferred'}`, añadir guard: si `pref.solo_grupos_objetivo`, verificar que `(preferencias[pref.id]||[]).some(p => p.plantilla_id === subj.plantilla_id && p.grupo_clave === g.clave)` — si no hay coincidencia, anular `pref` y caer a free selection.
- [x] 2.2 En el mismo bloque, añadir guard previo: si `!subj.plantilla_id`, saltarse el path `preferred` completamente (ir directo a free selection) para evitar comparación `null === null`.

## 3. Bypass de hrs_carga para maestros preferidos con solo_grupos_objetivo

- [x] 3.1 Modificar `pickTeacherForSubject` para retornar `{teacher, cause, ignoreCapacity}` donde `ignoreCapacity = (cause === 'preferred' && teacher.solo_grupos_objetivo === true)`.
- [x] 3.2 En el loop principal de `runEngine`, propagar `ignoreCapacity` desde el resultado de `pick` hasta las llamadas a `findPairTeacher` y Phase 2.
- [x] 3.3 En `findPairTeacher`, agregar parámetro `ignoreCapacity=false`. En Pass 1, reemplazar `if(usedHrs+2>cand.hrs_carga+1)continue` por `if(!ignoreCapacity&&usedHrs+2>cand.hrs_carga+1)continue`. Hacer lo mismo en Pass 2.
- [x] 3.4 En Phase 2 (horas sueltas), reemplazar `if(usedHrs>=cand.hrs_carga)continue` por `if(!ignoreCapacity&&usedHrs>=cand.hrs_carga)continue`.

## 4. Validación manual

- [x] 4.1 Ejecutar el motor con un maestro que tenga slots marcados como NO disponibles; verificar que ninguna sugerencia generada cae en esos slots.
- [x] 4.2 Activar `solo_grupos_objetivo` en un maestro con preferencias para 2 grupos; ejecutar el motor y verificar que ese maestro no aparece en grupos fuera de sus preferencias.
- [x] 4.3 Con el mismo maestro, verificar que cubre todas las horas de sus grupos preferidos aunque el total supere `hrs_carga`.
- [x] 4.4 Verificar que maestros sin `solo_grupos_objetivo` siguen siendo truncados por `hrs_carga` (comportamiento sin cambio).
