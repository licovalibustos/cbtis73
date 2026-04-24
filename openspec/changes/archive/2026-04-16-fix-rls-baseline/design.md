## Context

Supabase emitió un alert crítico (`rls_disabled_in_public`) porque 8 tablas del proyecto no tienen Row-Level Security habilitado. Estas son las tablas originales del sistema que existían antes de que se introdujeran migraciones formales. Las tablas creadas después (`materias_catalogo`, `asignaciones`, `maestros_plazas`) ya tienen RLS. La aplicación accede a Supabase con la `anon key` visible en el código fuente — sin políticas RLS, cualquier persona con la URL del proyecto puede leer, modificar y eliminar datos sin restricciones.

Tablas afectadas: `ciclos`, `grupos`, `horario`, `maestros`, `disponibilidad`, `competencias`, `materias_plantilla`. La tabla `materias` (legacy) fue excluida porque no existe en producción (error 42P01 al ejecutar).

## Goals / Non-Goals

**Goals:**
- Habilitar RLS en las 8 tablas afectadas
- Silenciar el alert de Supabase sin cambiar el comportamiento de la app
- Establecer la línea base sobre la que `auth-admin` construirá las políticas restrictivas

**Non-Goals:**
- Restringir acceso de escritura (eso es scope de `auth-admin`)
- Modificar código en `sistema_horarios_v1.html` o `maestro.html`
- Revisar o modificar las tablas que ya tienen RLS

## Decisions

**D1 — Policies abiertas `USING (true) WITH CHECK (true)` en todas las tablas**

Alternativa descartada: habilitar RLS sin crear policy → el default de PostgreSQL niega todo acceso cuando RLS está activo y no hay policy. Esto rompería la app inmediatamente al correr el script.

Decisión: crear una policy permisiva por tabla. Reproduce el comportamiento actual (acceso total anónimo) mientras silencia el alert. La restricción real se implementa en `auth-admin`.

**D2 — Un único script SQL, ejecutado manualmente en el SQL Editor de Supabase**

Alternativa descartada: scripts separados por tabla → riesgo de aplicar parcialmente y dejar el estado inconsistente.

Decisión: un solo bloque SQL ejecutado en una sola pasada. Si falla por cualquier razón (tabla ya con RLS, política duplicada), el error es visible de inmediato y no deja estado intermedio silencioso.

**D3 — Excluir `materias` porque no existe en producción**

Al ejecutar el script, la tabla `materias` arrojó el error `42P01: relation "materias" does not exist`. No existe en producción — las referencias en `sistema_horarios_v1.html` (`dbPatch('materias', ...)`, `dbGet('materias', ...)`) son deuda técnica. Se excluyó del fix; el migration.sql cubre 7 tablas.

## Risks / Trade-offs

- **[Risk] Policy duplicada** — Si alguna tabla ya tiene RLS habilitado o una policy con el mismo nombre, el script fallará en esa sentencia. → Mitigation: usar `IF NOT EXISTS` en `CREATE POLICY` no está soportado en PostgreSQL; en su lugar, el script usa `DROP POLICY IF EXISTS` antes de crear cada policy.
- **[Risk] `materias` es tabla zombi con datos** — Si se elimina en el futuro, sus policies quedan huérfanas. → Mitigation: no es riesgo funcional; las policies se eliminan automáticamente al hacer `DROP TABLE`.
- **[Trade-off] Policies abiertas no son "seguras" semánticamente** — El alert desaparece pero el riesgo de escritura no autorizada persiste. Esto es aceptado intencionalmente; `auth-admin` resolverá el riesgo real.

## Migration Plan

1. Abrir **Supabase Dashboard → SQL Editor** del proyecto CBTis73
2. Pegar y ejecutar el script `migration.sql` de este change completo, en un solo bloque
3. Verificar en **Database → Tables** que cada tabla muestra RLS = enabled
4. Verificar que la app (`sistema_horarios_v1.html`) sigue funcionando normalmente
5. El alert de Supabase desaparece en el siguiente ciclo de verificación (típicamente minutos)

**Rollback:** `ALTER TABLE <tabla> DISABLE ROW LEVEL SECURITY;` por cada tabla afectada.
