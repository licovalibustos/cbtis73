-- Migration: motor-asignacion-maestro-unico
-- Adds solo_grupos_objetivo boolean column to maestros table.
-- Run this in the Supabase SQL Editor before deploying the UI changes.

ALTER TABLE maestros
  ADD COLUMN IF NOT EXISTS solo_grupos_objetivo boolean NOT NULL DEFAULT false;
