## Context

El sistema `sistema_horarios_v1.html` es una Single Page Application en HTML/JS puro que persiste datos en Supabase (PostgreSQL). La tabla `materias` tiene una FK a `grupos`, lo que obliga a duplicar cada materia para cada grupo que la imparte. Con ~16 grupos por semestre y 5-7 materias troncales, esto genera ~80-112 filas redundantes solo para materias troncales, más las CFP por especialidad.

El flujo real de la escuela es: primero se define el catálogo de materias del semestre, luego se distribuye qué maestro da cada materia en cada grupo (el "Excel de distribución"). El sistema debe replicar ese flujo.

Stack relevante: HTML+JS vanilla, Supabase REST API (sin SDK), datos en memoria con patrón `ensure*()`/`_orig*()`.

## Goals / Non-Goals

**Goals:**
- Separar catálogo de materias (una por semestre) de asignaciones (maestro × grupo × materia)
- Soportar los 3 tipos de materia: troncal, optativa, CFP con sub-módulos
- Rediseñar la UI de Materias para ser materia-céntrica (como el Excel)
- Actualizar el motor de asignación para leer desde la nueva estructura
- Migrar datos existentes sin perder información

**Non-Goals:**
- Importar el Excel automáticamente (se captura manualmente en el sistema)
- Cambiar el motor de asignación de slots (solo actualizar la fuente de datos)
- Modificar `maestro.html` (pantalla de disponibilidad de maestros)
- Sistema de roles o permisos

## Decisions

### D1: Dos tablas nuevas en lugar de ampliar `materias`

**Decisión:** Crear `materias_catalogo` y `asignaciones`, y vaciar/eliminar `materias`.

**Rationale:** Ampliar `materias` con una FK opcional a catálogo crearía una estructura híbrida difícil de mantener. El corte limpio permite que toda la lógica downstream (motor, horario, impresión) tenga una fuente de verdad clara.

**Alternativa descartada:** Agregar `maestro_id` a la tabla `materias` actual. No resuelve la duplicación y mezcla catálogo con asignación.

---

### D2: `especialidad` como texto libre en catálogo, no FK

**Decisión:** `especialidad` es un VARCHAR nullable ('A', 'L', 'M', 'P', 'S', 'C') en `materias_catalogo`, no una tabla separada.

**Rationale:** Las especialidades son un conjunto pequeño y estable. Agregar una tabla `especialidades` solo añade complejidad sin beneficio real en este contexto.

---

### D3: El catálogo es por `ciclo_id`, no global

**Decisión:** `materias_catalogo` tiene FK a `ciclos`, no es un catálogo global reutilizable entre ciclos.

**Rationale:** El nombre, horas y distribución de materias puede cambiar cada ciclo (planes de estudio, modificaciones SEP). Al copiarlo por ciclo (igual que se copian grupos), se mantiene independencia e historial.

**Consecuencia:** Al crear un nuevo ciclo con "Copiar de ciclo anterior", se copia también el catálogo de materias (sin asignaciones de maestros, que empiezan en blanco).

---

### D4: La UI principal es materia-céntrica, con vista secundaria por grupo

**Decisión:** La pantalla Materias muestra primero el catálogo por semestre. Al seleccionar una materia se despliega la tabla de asignaciones (grupos × maestro). La vista por grupo queda como panel de detalle en la pantalla Grupos.

**Rationale:** Replica exactamente el Excel de distribución. La pregunta más frecuente es "¿quién da Inglés I en cada grupo?" no "¿qué materias tiene el grupo 3AML?".

---

### D5: Migración destructiva de `materias` con script SQL

**Decisión:** Script SQL en Supabase que: (1) inserta en `materias_catalogo` las materias únicas por nombre+semestre, (2) inserta en `asignaciones` con `maestro_id = null`, (3) vacía `materias`.

**Rationale:** Los datos actuales son pocos (no hay producción real aún). Un script limpio es más seguro que una migración incremental.

## Risks / Trade-offs

- **[Risk] El motor `runEngine` asume `subjects[cicloId][groupId]`** → Actualizar la función `ensureSubjectsForGroup()` para que construya este array desde `asignaciones` y `materias_catalogo` antes de llamar al motor. El motor interno no cambia.

- **[Risk] Copia de ciclo anterior no copia asignaciones de maestros** → Es intencional (cada ciclo tiene su distribución), pero puede confundir. Agregar mensaje informativo en la UI.

- **[Risk] Grupos de 1er sem tienen especialidad null (TC)** → Las materias troncales con `especialidad = null` se asignan a todos los grupos del semestre sin filtrar por especialidad. CFP no aplica a 1er semestre.

- **[Trade-off] Catálogo por ciclo vs. global** → Si SEP cambia horas de una materia, hay que editarla en cada ciclo manualmente. Aceptable dado el volumen.

## Migration Plan

1. **Crear tablas en Supabase** (SQL manual en dashboard):
   - `materias_catalogo` con campos: `id, ciclo_id, semestre, tipo, especialidad, nombre, hrs, hrs_lab`
   - `asignaciones` con campos: `id, materia_id, grupo_id, maestro_id, maestro_lab_id`
   - RLS: mismas políticas que `materias` actual

2. **Migrar datos existentes** (script SQL):
   ```sql
   -- Insertar catálogo desde materias únicas
   INSERT INTO materias_catalogo (ciclo_id, semestre, tipo, nombre, hrs, hrs_lab)
   SELECT DISTINCT g.ciclo_id, g.semestre, 'troncal', m.nombre, m.hrs, m.hrs_lab
   FROM materias m JOIN grupos g ON m.grupo_id = g.id;

   -- Insertar asignaciones sin maestro
   INSERT INTO asignaciones (materia_id, grupo_id, maestro_id)
   SELECT mc.id, m.grupo_id, null
   FROM materias m
   JOIN grupos g ON m.grupo_id = g.id
   JOIN materias_catalogo mc ON mc.ciclo_id = g.ciclo_id AND mc.nombre = m.nombre;
   ```

3. **Desplegar nuevo código** (reemplazar `sistema_horarios_v1.html`)

4. **Rollback**: restaurar `materias` desde backup. La tabla no se elimina hasta validar producción.

## Open Questions

- ¿Las horas de `TEMAS SELECTOS DE MATEMÁTICAS II` del 5to semestre no tienen número en el Excel — hay que definirlas manualmente?
- ¿Los sub-módulos de CFP (SUB 1, SUB 2, SUB 3) deben ser registros separados en `materias_catalogo`, o campos dentro de un mismo registro? → **Decisión tentativa: registros separados**, para poder asignar maestros distintos por sub-módulo.
