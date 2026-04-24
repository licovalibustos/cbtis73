### Requirement: RLS habilitado en todas las tablas públicas
Las 7 tablas originales de la base de datos del proyecto CBTis73 que son accesibles vía la API REST de Supabase SHALL tener Row-Level Security habilitado. Ninguna tabla SHALL aparecer en el reporte `rls_disabled_in_public` de Supabase.

#### Scenario: Tablas originales con RLS habilitado
- **WHEN** se ejecuta el script de migración en Supabase
- **THEN** las tablas `ciclos`, `grupos`, `horario`, `maestros`, `disponibilidad`, `competencias` y `materias_plantilla` tienen RLS habilitado (`rowsecurity = true` en `pg_tables`)

#### Scenario: Alert de Supabase resuelto
- **WHEN** Supabase ejecuta su verificación de seguridad después de la migración
- **THEN** el proyecto CBTis73 no aparece en el reporte `rls_disabled_in_public`

---

### Requirement: Acceso anónimo sin cambios funcionales
Las tablas afectadas SHALL mantener el mismo comportamiento de acceso que tenían antes de habilitar RLS. Cualquier cliente con la `anon key` SHALL poder leer y escribir en todas las tablas, igual que antes.

#### Scenario: Lectura anónima sigue funcionando
- **WHEN** `sistema_horarios_v1.html` hace `dbGet` a cualquiera de las tablas afectadas usando la `anon key`
- **THEN** la respuesta es HTTP 200 con los datos correctos

#### Scenario: Escritura anónima sigue funcionando
- **WHEN** `sistema_horarios_v1.html` hace `dbPatch` o `dbUpsert` a cualquiera de las tablas afectadas usando la `anon key`
- **THEN** la operación se completa con éxito y los datos se persisten en la base de datos

#### Scenario: `maestro.html` sigue funcionando sin cambios
- **WHEN** un maestro accede a `maestro.html` con su token de URL y guarda su disponibilidad
- **THEN** la escritura en la tabla `disponibilidad` se completa correctamente

---

### Requirement: Compatibilidad con `auth-admin` futuro
Las policies creadas en este change SHALL usar nombres de convención `anon_all_<tabla>` para poder ser identificadas y reemplazadas de forma selectiva por el change `auth-admin` sin afectar otras policies.

#### Scenario: Policy identificable por nombre
- **WHEN** se implementa el change `auth-admin`
- **THEN** es posible hacer `DROP POLICY "anon_all_<tabla>" ON <tabla>` y crear una policy restrictiva en su lugar sin modificar otras policies existentes
