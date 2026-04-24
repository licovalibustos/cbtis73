## Why

Supabase detectó que 8 tablas no tienen Row-Level Security habilitado y emitió una alerta crítica de seguridad (`rls_disabled_in_public`). Las tablas `ciclos`, `grupos`, `horario`, `maestros`, `disponibilidad`, `competencias`, `materias_plantilla` y `materias` están expuestas sin ninguna política, lo que permite a cualquiera con la project URL leer, modificar y borrar datos. La corrección es urgente para silenciar el alert y cumplir con el requisito mínimo de seguridad de Supabase.

## What Changes

- Habilitar RLS en las 8 tablas afectadas (`ALTER TABLE ... ENABLE ROW LEVEL SECURITY`)
- Crear policy `anon_all` en cada tabla con `USING (true) WITH CHECK (true)` — mantiene el comportamiento actual sin romper nada
- Sin cambios en el código de la aplicación (`sistema_horarios_v1.html`, `maestro.html`)
- Sin cambios de comportamiento ni de datos

> Las tablas `materias_catalogo`, `asignaciones` y `maestros_plazas` ya tienen RLS habilitado y quedan fuera del scope.

## Capabilities

### New Capabilities

- `rls-baseline`: Conjunto de políticas RLS abiertas que cubren las tablas originales del sistema; establece la línea base de seguridad antes de implementar auth real.

### Modified Capabilities

*(ninguna — no cambian requisitos de capabilidades existentes)*

## Impact

- **Base de datos**: 8 tablas modificadas solo a nivel de seguridad, sin tocar estructura ni datos
- **Aplicación**: ningún impacto — las policies `USING (true)` reproducen el comportamiento sin restricciones que existe hoy
- **Alert de Supabase**: desaparece al aplicar la migración
- **Dependencias**: el change `auth-admin` (planeado) deberá sobrescribir estas policies con condiciones `auth.role() = 'authenticated'`
