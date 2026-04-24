-- ============================================================
-- Migration: plantilla-materias-competencias
-- Run each block in Supabase SQL editor, verifying before
-- proceeding to the next step.
-- ============================================================

-- STEP 1.1 — Crear tabla global de plantillas
CREATE TABLE materias_plantilla (
  id     uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre text UNIQUE NOT NULL
);

-- STEP 1.2 — Poblar desde nombres únicos del catálogo (normalizados)
INSERT INTO materias_plantilla (nombre)
SELECT DISTINCT UPPER(TRIM(nombre))
FROM materias_catalogo
ORDER BY 1;

-- STEP 1.3 — Agregar FK a materias_catalogo y mapear por nombre normalizado
ALTER TABLE materias_catalogo
  ADD COLUMN plantilla_id uuid REFERENCES materias_plantilla(id);

UPDATE materias_catalogo mc
SET plantilla_id = mp.id
FROM materias_plantilla mp
WHERE UPPER(TRIM(mc.nombre)) = mp.nombre;

-- STEP 1.4 — Verificar que no quedan nulos en materias_catalogo (debe ser 0)
-- SELECT COUNT(*) FROM materias_catalogo WHERE plantilla_id IS NULL;

-- STEP 1.5 — Agregar FK a competencias y mapear por materia string normalizado
ALTER TABLE competencias
  ADD COLUMN plantilla_id uuid REFERENCES materias_plantilla(id);

UPDATE competencias c
SET plantilla_id = mp.id
FROM materias_plantilla mp
WHERE UPPER(TRIM(c.materia)) = mp.nombre;

-- STEP 1.6 — Verificar que no quedan nulos en competencias (debe ser 0)
-- SELECT COUNT(*) FROM competencias WHERE plantilla_id IS NULL;

-- STEP 1.7 — Hacer NOT NULL y eliminar la columna texto obsoleta
ALTER TABLE competencias
  ALTER COLUMN plantilla_id SET NOT NULL,
  DROP COLUMN materia;

-- ============================================================
-- ROLLBACK (antes del step 1.7):
--   DROP TABLE materias_plantilla CASCADE;
-- Después del step 1.7 se requiere restore desde backup.
-- ============================================================
