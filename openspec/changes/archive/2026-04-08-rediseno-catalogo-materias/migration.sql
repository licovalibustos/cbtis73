-- ════════════════════════════════════════════════════════════
--  CBTIS 73 — Rediseño Catálogo de Materias
--  Ejecutar en: Supabase Dashboard → SQL Editor
--  Orden: 1) crear tablas  2) migrar datos  3) RLS
-- ════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────
--  1.1  Tabla materias_catalogo
-- ───────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS materias_catalogo (
  id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  ciclo_id    uuid        NOT NULL REFERENCES ciclos(id) ON DELETE CASCADE,
  semestre    integer     NOT NULL CHECK (semestre BETWEEN 1 AND 6),
  tipo        text        NOT NULL CHECK (tipo IN ('troncal','optativa','cfp')),
  especialidad text       NULL,          -- código: 'A'|'C'|'L'|'M'|'P'|'S'
  nombre      text        NOT NULL,
  hrs         integer     NOT NULL DEFAULT 1,
  hrs_lab     integer     NOT NULL DEFAULT 0,
  created_at  timestamptz DEFAULT now()
);

-- ───────────────────────────────────────────────────────────
--  1.2  Tabla asignaciones
--       NOTA: maestros.id es TEXT (ej. 'T01'), grupos.id es uuid
-- ───────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS asignaciones (
  id              uuid  PRIMARY KEY DEFAULT gen_random_uuid(),
  materia_id      uuid  NOT NULL REFERENCES materias_catalogo(id) ON DELETE CASCADE,
  grupo_id        uuid  NOT NULL REFERENCES grupos(id) ON DELETE CASCADE,
  maestro_id      text  NULL REFERENCES maestros(id) ON DELETE SET NULL,
  maestro_lab_id  text  NULL REFERENCES maestros(id) ON DELETE SET NULL,
  created_at      timestamptz DEFAULT now(),
  UNIQUE (materia_id, grupo_id)
);

-- ───────────────────────────────────────────────────────────
--  1.3  Índices
-- ───────────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_asig_materia  ON asignaciones(materia_id);
CREATE INDEX IF NOT EXISTS idx_asig_grupo    ON asignaciones(grupo_id);
CREATE INDEX IF NOT EXISTS idx_cat_ciclo_sem ON materias_catalogo(ciclo_id, semestre);

-- ───────────────────────────────────────────────────────────
--  1.4  Row Level Security — mismas reglas que tablas existentes
--       (lectura pública, escritura con la misma anon key ya que
--        no hay auth configurado en este proyecto)
-- ───────────────────────────────────────────────────────────
ALTER TABLE materias_catalogo ENABLE ROW LEVEL SECURITY;
ALTER TABLE asignaciones      ENABLE ROW LEVEL SECURITY;

-- Permitir todo al rol anon (igual que el resto de tablas del proyecto)
CREATE POLICY "anon_all_materias_catalogo"
  ON materias_catalogo FOR ALL TO anon USING (true) WITH CHECK (true);

CREATE POLICY "anon_all_asignaciones"
  ON asignaciones FOR ALL TO anon USING (true) WITH CHECK (true);

-- ───────────────────────────────────────────────────────────
--  1.5  Migración de datos desde tabla `materias` legacy
--        (ejecutar solo si ya existen datos en `materias`)
-- ───────────────────────────────────────────────────────────

-- Paso 1: Insertar catálogo — materias únicas por ciclo+semestre+nombre
INSERT INTO materias_catalogo (ciclo_id, semestre, tipo, nombre, hrs, hrs_lab)
SELECT DISTINCT
  g.ciclo_id,
  g.semestre,
  'troncal' AS tipo,
  m.nombre,
  m.hrs,
  m.hrs_lab
FROM materias m
JOIN grupos g ON m.grupo_id = g.id
ON CONFLICT DO NOTHING;

-- Paso 2: Insertar asignaciones (sin maestro de aula por omisión)
INSERT INTO asignaciones (materia_id, grupo_id, maestro_id, maestro_lab_id)
SELECT DISTINCT
  mc.id,
  m.grupo_id,
  NULL,                  -- maestro se reasigna manualmente
  m.maestro_lab_id
FROM materias m
JOIN grupos g   ON m.grupo_id = g.id
JOIN materias_catalogo mc
  ON mc.ciclo_id = g.ciclo_id
 AND mc.nombre   = m.nombre
ON CONFLICT (materia_id, grupo_id) DO NOTHING;

-- ───────────────────────────────────────────────────────────
--  Verificación rápida
-- ───────────────────────────────────────────────────────────
-- SELECT count(*) FROM materias_catalogo;
-- SELECT count(*) FROM asignaciones;
