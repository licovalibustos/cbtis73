-- ============================================================
-- Migration: plazas-maestros
-- Ejecutar en Supabase SQL Editor
-- ============================================================

-- Fase 1: campos de encabezado del expediente en maestros
ALTER TABLE maestros
  ADD COLUMN IF NOT EXISTS grado text,
  ADD COLUMN IF NOT EXISTS egresado_de text,
  ADD COLUMN IF NOT EXISTS especialidad_acad text,
  ADD COLUMN IF NOT EXISTS departamento text;

-- Fase 2: tabla de plazas presupuestales (1:N con maestros)
CREATE TABLE IF NOT EXISTS maestros_plazas (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  maestro_id text NOT NULL REFERENCES maestros(id) ON DELETE CASCADE,
  plaza text NOT NULL,
  fecha_ingreso_sep text,
  fecha_ingreso_dgeti text,
  condicion_nom smallint CHECK (condicion_nom IN (1,2,3)),
  turno char(1) CHECK (turno IN ('M','V','A'))
);

-- Fase 3: RLS (equivalente a politicas de maestros)
ALTER TABLE maestros_plazas ENABLE ROW LEVEL SECURITY;

CREATE POLICY "public read maestros_plazas"
  ON maestros_plazas FOR SELECT USING (true);

CREATE POLICY "anon write maestros_plazas"
  ON maestros_plazas FOR ALL USING (true) WITH CHECK (true);
