## 1. Base de datos — Migración RLS

- [x] 1.1 Ejecutar `migration.sql` en Supabase SQL Editor (habilita RLS y crea policies `anon_all_*` en las 7 tablas)
- [x] 1.2 Verificar en Supabase Dashboard → Database → Tables que las 7 tablas muestran RLS = enabled

## 2. Validación

- [x] 2.1 Abrir `sistema_horarios_v1.html` y cargar un ciclo — confirmar que grupos, materias y asignaciones cargan sin errores en consola
- [x] 2.2 Editar un maestro y guardar — confirmar que `dbPatch('maestros', ...)` responde 200
- [x] 2.3 Abrir `maestro.html` con un token de maestro válido — confirmar que la disponibilidad carga y se puede guardar
- [x] 2.4 Confirmar que el alert `rls_disabled_in_public` ya no aparece en Supabase (puede tardar minutos)
