## 1. Base de datos (Supabase)

- [x] 1.1 Crear tabla `materias_catalogo` en Supabase: `id uuid PK, ciclo_id uuid FK, semestre int, tipo text CHECK('troncal','optativa','cfp'), especialidad text nullable, nombre text, hrs int, hrs_lab int DEFAULT 0`
- [x] 1.2 Crear tabla `asignaciones` en Supabase: `id uuid PK, materia_id uuid FK materias_catalogo, grupo_id uuid FK grupos, maestro_id uuid nullable FK maestros, maestro_lab_id uuid nullable FK maestros`
- [x] 1.3 Agregar índices: `asignaciones(materia_id)`, `asignaciones(grupo_id)`, `materias_catalogo(ciclo_id, semestre)`
- [x] 1.4 Configurar RLS en ambas tablas (lectura pública, escritura con service key igual que tablas existentes)
- [x] 1.5 Ejecutar script SQL de migración de datos desde `materias` a `materias_catalogo` + `asignaciones`

## 2. Capa de datos en JS (loaders y caché)

- [x] 2.1 Agregar variables de estado: `catalogo = {}` (keyed por cicloId) y `asignaciones = {}` (keyed por cicloId)
- [x] 2.2 Implementar `ensureCatalogo(cicloId)`: carga `materias_catalogo` para el ciclo desde Supabase
- [x] 2.3 Implementar `ensureAsignaciones(cicloId, materiaId)`: carga asignaciones de una materia específica
- [x] 2.4 Implementar `ensureAsignacionesGrupo(cicloId, grupoDbId)`: carga asignaciones de un grupo (para el motor y detalle de grupo)
- [x] 2.5 Actualizar `saveNuevoCiclo` para copiar `materias_catalogo` del ciclo origen (sin asignaciones)
- [x] 2.6 Actualizar `onCicloChange` para limpiar `catalogo[id]` y `asignaciones[id]` al cambiar ciclo

## 3. UI — Catálogo de materias

- [x] 3.1 Rediseñar la vista `view-materias`: reemplazar selector de grupo por selector de semestre (tabs 1°–6°)
- [x] 3.2 Implementar `renderCatalogo(semestre)`: muestra lista de materias agrupadas por tipo (troncal, optativa, cfp+especialidad)
- [x] 3.3 Implementar modal de nueva/editar materia en catálogo: campos nombre, hrs, hrs_lab, tipo, especialidad
- [x] 3.4 Implementar `saveMateriasCatalogo()`: POST/PATCH a `materias_catalogo` + actualizar cache
- [x] 3.5 Implementar `delMateriaCatalogo()`: DELETE en `materias_catalogo` y sus `asignaciones` en cascada

## 4. UI — Distribución (asignación maestro × grupo)

- [x] 4.1 Al seleccionar una materia del catálogo, mostrar panel de asignaciones con tabla grupos × maestro
- [x] 4.2 Filtrar grupos por semestre para troncales; por semestre+especialidad para CFP; por grupos asignados para optativas
- [x] 4.3 Panel de asignaciones muestra tabla informativa de grupos (sin dropdown de maestro); la asignación de maestros se realiza en Asignación Automática
- [x] 4.4 Las asignaciones (sin maestro) se crean automáticamente al seleccionar la materia o al crear grupo/materia; `saveAsignacion` fue eliminada por no ser necesaria
- [x] 4.5 Mostrar indicador de estado: "✓ asignado" (verde) / "⚠ pendiente" (ámbar) por fila
- [x] 4.6 Actualizar panel de detalle de grupo en vista Grupos para leer materias desde `asignaciones` del grupo

## 5. Motor de asignación de horarios

- [x] 5.1 Crear función `subjectsFromAsignaciones(grupoDbId)`: construye el array `[{name, hrs, lab, teacherId}]` desde `asignaciones` + `materias_catalogo` para un grupo
- [x] 5.2 Actualizar el override patched de `renderGrupos` para usar `ensureAsignacionesGrupo` en lugar de `ensureSubjects`
- [x] 5.3 Actualizar `runEngine` para llamar `subjectsFromAsignaciones` en lugar de `subjects[cicloId][g.id]`
- [x] 5.4 Verificar que detección de conflictos y `assignedHrs` siguen funcionando correctamente

## 6. Validación y limpieza

- [x] 6.1 Probar flujo completo: crear materia troncal → asignar maestros a todos los grupos → ejecutar motor → ver horario generado
- [x] 6.2 Probar flujo CFP: crear sub-módulo de especialidad → solo aparecen grupos de esa especialidad
- [x] 6.3 Probar copia de ciclo: el catálogo se copia, las asignaciones empiezan vacías
- [x] 6.4 Eliminar o vaciar tabla `materias` legacy una vez validado en producción
