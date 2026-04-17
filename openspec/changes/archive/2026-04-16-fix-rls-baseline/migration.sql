-- ============================================================
-- Migration: fix-rls-baseline
-- Habilita Row-Level Security en las 8 tablas originales del
-- proyecto que no tenian RLS. Las policies son abiertas
-- (USING true) para mantener comportamiento existente sin
-- romper la aplicacion.
--
-- Ejecutar completo en Supabase SQL Editor en una sola pasada.
-- ============================================================

-- ciclos
ALTER TABLE ciclos ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all_ciclos" ON ciclos;
CREATE POLICY "anon_all_ciclos"
  ON ciclos FOR ALL
  USING (true)
  WITH CHECK (true);

-- grupos
ALTER TABLE grupos ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all_grupos" ON grupos;
CREATE POLICY "anon_all_grupos"
  ON grupos FOR ALL
  USING (true)
  WITH CHECK (true);

-- horario
ALTER TABLE horario ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all_horario" ON horario;
CREATE POLICY "anon_all_horario"
  ON horario FOR ALL
  USING (true)
  WITH CHECK (true);

-- maestros
ALTER TABLE maestros ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all_maestros" ON maestros;
CREATE POLICY "anon_all_maestros"
  ON maestros FOR ALL
  USING (true)
  WITH CHECK (true);

-- disponibilidad
ALTER TABLE disponibilidad ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all_disponibilidad" ON disponibilidad;
CREATE POLICY "anon_all_disponibilidad"
  ON disponibilidad FOR ALL
  USING (true)
  WITH CHECK (true);

-- competencias
ALTER TABLE competencias ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all_competencias" ON competencias;
CREATE POLICY "anon_all_competencias"
  ON competencias FOR ALL
  USING (true)
  WITH CHECK (true);

-- materias_plantilla
ALTER TABLE materias_plantilla ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "anon_all_materias_plantilla" ON materias_plantilla;
CREATE POLICY "anon_all_materias_plantilla"
  ON materias_plantilla FOR ALL
  USING (true)
  WITH CHECK (true);

-- Nota: la tabla "materias" (legacy) ya no existe en produccion.
-- El codigo que la referencia es deuda tecnica pendiente de limpiar.
