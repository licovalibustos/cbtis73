## Why

Hoy la vista de “Horario Maestro” sólo muestra el horario en pantalla o lo imprime como HTML/PDF-like. Para capturar la distribución oficial en Excel todavía hay que copiar datos manualmente al formato SEP/DGETI, lo que consume tiempo y aumenta el riesgo de errores.

## What Changes

- Agregar una exportación a Excel del horario por maestro desde la vista “Horario Maestro”.
- Generar un `.xlsx` a partir de una plantilla oficial con logos, formatos, merges y firmas preservadas.
- Poblar automáticamente los datos del maestro, su carga académica y la grilla de turnos/lunes-viernes.
- Mantener la impresión actual sin cambios y añadir la opción de exportación como flujo separado.

## Capabilities

### New Capabilities
- `horario-maestro-excel`: exportación del horario por maestro a Excel usando la plantilla oficial.

### Modified Capabilities
- Ninguna.

## Goals / Non-Goals

**Goals:** generar un archivo Excel fiel al formato institucional, reutilizando los datos ya cargados en la app para un maestro y un ciclo activos.

**Non-Goals:** no cambiar el motor de asignación, no modificar tablas de Supabase y no sustituir la vista actual de impresión.

## Impact

Impacta `sistema_horarios_v1.html` y `sistema_horarios_v1_copia.html` en la sección de Horario Maestro. Dependencias nuevas: JSZip en CDN y la plantilla Excel base. Tablas de Supabase afectadas: ninguna; la exportación sólo lee `maestros`, `grupos`, `horario`, `disponibilidad` y `ciclos`.