-- migration: preferencias-asignacion-maestros
-- Crea tabla maestro_preferencias para reglas permanentes maestro × materia × grupo

CREATE TABLE IF NOT EXISTS public.maestro_preferencias (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  maestro_id    text NOT NULL REFERENCES public.maestros(id) ON DELETE CASCADE,
  plantilla_id  uuid NOT NULL REFERENCES public.materias_plantilla(id) ON DELETE CASCADE,
  grupo_clave   text NOT NULL,
  CONSTRAINT maestro_preferencias_uq UNIQUE (maestro_id, plantilla_id, grupo_clave)
);

-- Índices para queries frecuentes del motor y la UI
CREATE INDEX IF NOT EXISTS idx_maestro_preferencias_maestro ON public.maestro_preferencias(maestro_id);
CREATE INDEX IF NOT EXISTS idx_maestro_preferencias_grupo ON public.maestro_preferencias(grupo_clave);

-- RLS
ALTER TABLE public.maestro_preferencias ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated read maestro_preferencias"
  ON public.maestro_preferencias FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated write maestro_preferencias"
  ON public.maestro_preferencias FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated delete maestro_preferencias"
  ON public.maestro_preferencias FOR DELETE
  TO authenticated
  USING (true);
