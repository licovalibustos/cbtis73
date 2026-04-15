-- ============================================================
--  fix_maestros_uuid_to_txx.sql
--  Reasigna IDs de maestros con UUID al formato T## (T01, T02…)
--  Actualiza todas las tablas que referencian maestros.id
-- ============================================================
--  Tablas afectadas:
--    competencias   → maestro_id
--    disponibilidad → maestro_id
--    asignaciones   → maestro_id, maestro_lab_id
--    horario        → maestro_id
-- ============================================================
--  Cómo ejecutar: pega este script en el SQL Editor de Supabase
-- ============================================================

BEGIN;

DO $$
DECLARE
  r        RECORD;
  next_num INT;
  new_id   TEXT;
BEGIN
  -- Iterar sobre maestros con UUID, ordenados por nombre
  FOR r IN
    SELECT id, nombre
    FROM   maestros
    WHERE  id !~ '^T\d+$'
    ORDER  BY nombre
  LOOP
    -- Buscar el siguiente T## que NO esté ocupado (maneja huecos en la secuencia)
    next_num := 0;
    LOOP
      next_num := next_num + 1;
      new_id   := 'T' || LPAD(next_num::text, 2, '0');
      EXIT WHEN NOT EXISTS (SELECT 1 FROM maestros WHERE id = new_id);
    END LOOP;

    RAISE NOTICE 'Reasignando: % → %  (%)', r.id, new_id, r.nombre;

    -- Actualizar tablas hijo primero (FK constraints)
    UPDATE competencias   SET maestro_id     = new_id WHERE maestro_id     = r.id;
    UPDATE disponibilidad SET maestro_id     = new_id WHERE maestro_id     = r.id;
    UPDATE asignaciones   SET maestro_id     = new_id WHERE maestro_id     = r.id;
    UPDATE asignaciones   SET maestro_lab_id = new_id WHERE maestro_lab_id = r.id;
    UPDATE horario        SET maestro_id     = new_id WHERE maestro_id     = r.id;

    -- Actualizar el ID del maestro
    UPDATE maestros SET id = new_id WHERE id = r.id;
  END LOOP;

  RAISE NOTICE 'Migración completada.';
END $$;

-- Vista previa del resultado
SELECT id, nombre, rfc, categoria
FROM   maestros
ORDER  BY id;

COMMIT;
