-- Asignación de RFC (Filiación) y Categoría desde plantilla oficial
-- CBTis 73 — Generado: 2026-04-09
-- Ejecutar en Supabase SQL Editor (Dashboard → SQL Editor)
--
-- ESTRUCTURA: Por cada docente:
--   1. INSERT si el nombre NO existe (se omite automáticamente si ya existe).
--   2. UPDATE para asignar rfc + categoria en existentes y recién insertados.
--
-- NOTAS:
--   • Categoría asignada: mayor jerarquía/tiempo (Titular > Asociado > Asignatura).
--   • Docentes de ASIGNATURA o sin tiempo definido → hrs_nom=0, hrs_carga=0.
--     Ajustar en "Editar maestro" después de ejecutar.
--   • PROF TIT. "D" 3/4 → Chavez De La Cruz (única en ese nivel).

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'ACOSTA TERRAZAS MA. LUISA','AOTM590825G41','PROF TIT. "C" T/C',40,30 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'ACOSTA TERRAZAS%');
UPDATE maestros SET rfc='AOTM590825G41', categoria='PROF TIT. "C" T/C'     WHERE nombre ILIKE 'ACOSTA TERRAZAS%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'ALVAREZ SOLIS JUAN ALBERTO','AASJ6607141Z2','PROF TIT. "C" 3/4',30,22 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'ALVAREZ SOLIS%');
UPDATE maestros SET rfc='AASJ6607141Z2', categoria='PROF TIT. "C" 3/4'     WHERE nombre ILIKE 'ALVAREZ SOLIS%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'ARCOS VELAZQUEZ GABRIELA YATZIRI','AOVG930519C87','PROF ASOC. "A" 3/4',30,22 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'ARCOS VELAZQUEZ%');
UPDATE maestros SET rfc='AOVG930519C87', categoria='PROF ASOC. "A" 3/4'    WHERE nombre ILIKE 'ARCOS VELAZQUEZ%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'AVILA GONZALEZ GRASIELA','AIGG670430234','PROF TIT. "C" T/C',40,30 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'AVILA GONZALEZ%');
UPDATE maestros SET rfc='AIGG670430234', categoria='PROF TIT. "C" T/C'     WHERE nombre ILIKE 'AVILA GONZALEZ%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'AYALA MORALES EDGAR ISAAC','AAME7305055Q9','PROF ASIG. "C"',0,0 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'AYALA MORALES%');
UPDATE maestros SET rfc='AAME7305055Q9', categoria='PROF ASIG. "C"'        WHERE nombre ILIKE 'AYALA MORALES%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'BAUTISTA JAIME ALAIN RODRIGO','BAJA920714AC6','PROF ASIG. "C"',0,0 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'BAUTISTA JAIME%');
UPDATE maestros SET rfc='BAJA920714AC6', categoria='PROF ASIG. "C"'        WHERE nombre ILIKE 'BAUTISTA JAIME%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'BOLAÑOS CARMONA MA. GUADALUPE','BOCM580707J54','PROF TIT. "C" 3/4',30,22 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'BOLAÑOS CARMONA%');
UPDATE maestros SET rfc='BOCM580707J54', categoria='PROF TIT. "C" 3/4'     WHERE nombre ILIKE 'BOLAÑOS CARMONA%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'CHAVEZ DE LA CRUZ LETICIA','CACL680410NW2','PROF TIT. "D" 3/4',30,22 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'CHAVEZ DE LA CRUZ%');
UPDATE maestros SET rfc='CACL680410NW2', categoria='PROF TIT. "D" 3/4'     WHERE nombre ILIKE 'CHAVEZ DE LA CRUZ%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'CANCHOLA ESCALANTE JULIAN JAVIER','CAEJ680501U20','PROF TIT. "C" 1/2',20,16 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'CANCHOLA ESCALANTE%');
UPDATE maestros SET rfc='CAEJ680501U20', categoria='PROF TIT. "C" 1/2'     WHERE nombre ILIKE 'CANCHOLA ESCALANTE%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'CARRASCO GARCIA ESPERANZA','CAGE7812064N5','PROF TIT. "A" 3/4',30,22 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'CARRASCO GARCIA%');
UPDATE maestros SET rfc='CAGE7812064N5', categoria='PROF TIT. "A" 3/4'     WHERE nombre ILIKE 'CARRASCO GARCIA%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'DIAZ LOPEZ ARELY JAZMIN','DILA8408319U3','PROF TIT. "C" 3/4',30,22 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'DIAZ LOPEZ%');
UPDATE maestros SET rfc='DILA8408319U3', categoria='PROF TIT. "C" 3/4'     WHERE nombre ILIKE 'DIAZ LOPEZ%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'ESTRADA VILLANUEVA CARLOS FABIAN','EAVC780120GZ8','PROF TIT. "B" 3/4',30,22 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'ESTRADA VILLANUEVA%');
UPDATE maestros SET rfc='EAVC780120GZ8', categoria='PROF TIT. "B" 3/4'     WHERE nombre ILIKE 'ESTRADA VILLANUEVA%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'ESPINOZA LAZCANO SENON','EILS610709US0','PROF TIT. "C" T/C',40,30 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'ESPINOZA LAZCANO%');
UPDATE maestros SET rfc='EILS610709US0', categoria='PROF TIT. "C" T/C'     WHERE nombre ILIKE 'ESPINOZA LAZCANO%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'FELICIANO MARTINEZ GAUDENCIO','FEMG750122RF6','PROF ASIG. "C"',0,0 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'FELICIANO MARTINEZ%');
UPDATE maestros SET rfc='FEMG750122RF6', categoria='PROF ASIG. "C"'        WHERE nombre ILIKE 'FELICIANO MARTINEZ%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'FLORES ZARATE MARIA DEL CARMEN','FOZC700626G74','PROF TIT. "C" 3/4',30,22 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'FLORES ZARATE%');
UPDATE maestros SET rfc='FOZC700626G74', categoria='PROF TIT. "C" 3/4'     WHERE nombre ILIKE 'FLORES ZARATE%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'GARCIA CASTILLO JOSE FRANCISCO','GACF8301159D2','PROF ASIG. "A"',0,0 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'GARCIA CASTILLO%');
UPDATE maestros SET rfc='GACF8301159D2', categoria='PROF ASIG. "A"'        WHERE nombre ILIKE 'GARCIA CASTILLO%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'GARZA GARZA BEATRIZ ADRIANA','GAGB791222UP4','PROF ASIG. "C"',0,0 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'GARZA GARZA%');
UPDATE maestros SET rfc='GAGB791222UP4', categoria='PROF ASIG. "C"'        WHERE nombre ILIKE 'GARZA GARZA%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'GARZA HERNANDEZ LUZ ELENA','GAHL890425HU9','PROF ASOC. "A" 3/4',30,22 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'GARZA HERNANDEZ%');
UPDATE maestros SET rfc='GAHL890425HU9', categoria='PROF ASOC. "A" 3/4'    WHERE nombre ILIKE 'GARZA HERNANDEZ%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'GARCIA HERNANDEZ MIGUEL ANGEL','GAHM550804KB2','PROF TIT. "C" 3/4',30,22 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'GARCIA HERNANDEZ%');
UPDATE maestros SET rfc='GAHM550804KB2', categoria='PROF TIT. "C" 3/4'     WHERE nombre ILIKE 'GARCIA HERNANDEZ%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'GALVAN PEÑA PAMELA','GAPP900929362','PROF ASOC. "A" 1/2',20,16 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'GALVAN PEÑA%');
UPDATE maestros SET rfc='GAPP900929362', categoria='PROF ASOC. "A" 1/2'    WHERE nombre ILIKE 'GALVAN PEÑA%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'GARATE RODRIGUEZ ARACELY BELEM','GARA6706253H2','PROF ASIG. "C"',0,0 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'GARATE RODRIGUEZ%');
UPDATE maestros SET rfc='GARA6706253H2', categoria='PROF ASIG. "C"'        WHERE nombre ILIKE 'GARATE RODRIGUEZ%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'GARZA TAPIA PATRICIO','GATP780724IL1','PROF TIT. "B" T/C',40,30 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'GARZA TAPIA%');
UPDATE maestros SET rfc='GATP780724IL1', categoria='PROF TIT. "B" T/C'     WHERE nombre ILIKE 'GARZA TAPIA%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'GARCIA VAZQUEZ WENDY','GAVW890426459','PROF ASOC. "C" 1/2',20,16 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'GARCIA VAZQUEZ%');
UPDATE maestros SET rfc='GAVW890426459', categoria='PROF ASOC. "C" 1/2'    WHERE nombre ILIKE 'GARCIA VAZQUEZ%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'GONZALEZ ASENCIO MARCOS RENE','GOAM750415S52','PROF ASOC. "A" T/C',40,30 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'GONZALEZ ASENCIO%');
UPDATE maestros SET rfc='GOAM750415S52', categoria='PROF ASOC. "A" T/C'    WHERE nombre ILIKE 'GONZALEZ ASENCIO%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'GONZALEZ CHAPA GRACIELA EDITH','GOCG710827PJ5','PROF TIT. "C" 3/4',30,22 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'GONZALEZ CHAPA%');
UPDATE maestros SET rfc='GOCG710827PJ5', categoria='PROF TIT. "C" 3/4'     WHERE nombre ILIKE 'GONZALEZ CHAPA%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'GONZALEZ GARZA RIGOBERTO','GOGR561017CHA','PROF TIT. "C" 3/4',30,22 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'GONZALEZ GARZA%');
UPDATE maestros SET rfc='GOGR561017CHA', categoria='PROF TIT. "C" 3/4'     WHERE nombre ILIKE 'GONZALEZ GARZA%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'GONZALEZ MARTINEZ ARNULFO HOMERO','GOMA721128T20','PROF ASIG. "C"',0,0 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'GONZALEZ MARTINEZ%');
UPDATE maestros SET rfc='GOMA721128T20', categoria='PROF ASIG. "C"'        WHERE nombre ILIKE 'GONZALEZ MARTINEZ%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'GONZALEZ PAZ GLADYS MINERVA','GOPG821229EV8','PROF ASIG. "C"',0,0 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'GONZALEZ PAZ%');
UPDATE maestros SET rfc='GOPG821229EV8', categoria='PROF ASIG. "C"'        WHERE nombre ILIKE 'GONZALEZ PAZ%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'GUTIERREZ SILVA MALINTZIN YAJAIRA','GUSM801127K23','PROF TIT. "A" 3/4',30,22 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'GUTIERREZ SILVA%');
UPDATE maestros SET rfc='GUSM801127K23', categoria='PROF TIT. "A" 3/4'     WHERE nombre ILIKE 'GUTIERREZ SILVA%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'HERNANDEZ DORIA JORGE OMAR','HEDJ750429JH4','PROF ASIG. "C"',0,0 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'HERNANDEZ DORIA%');
UPDATE maestros SET rfc='HEDJ750429JH4', categoria='PROF ASIG. "C"'        WHERE nombre ILIKE 'HERNANDEZ DORIA%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'HERNANDEZ ORTEGA J ISABEL','HEOJ491119392','PROF TIT. "C" T/C',40,30 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'HERNANDEZ ORTEGA%');
UPDATE maestros SET rfc='HEOJ491119392', categoria='PROF TIT. "C" T/C'     WHERE nombre ILIKE 'HERNANDEZ ORTEGA%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'HERNANDEZ PONCE DANIEL','HEPD720916KW7','PROF ASOC. "C" 1/2',20,16 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'HERNANDEZ PONCE%');
UPDATE maestros SET rfc='HEPD720916KW7', categoria='PROF ASOC. "C" 1/2'    WHERE nombre ILIKE 'HERNANDEZ PONCE%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'IBARRA ALANIS ALEJANDRO','IAAA560801A68','PROF TIT. "C" T/C',40,30 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'IBARRA ALANIS%');
UPDATE maestros SET rfc='IAAA560801A68', categoria='PROF TIT. "C" T/C'     WHERE nombre ILIKE 'IBARRA ALANIS%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'IBARRA BELMARES KARINA LEONOR','IABK871116KH7','PROF ASIG. "A"',0,0 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'IBARRA BELMARES%');
UPDATE maestros SET rfc='IABK871116KH7', categoria='PROF ASIG. "A"'        WHERE nombre ILIKE 'IBARRA BELMARES%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'JARAMILLO HEREDIA ELDA GUADALUPE','JAHE920711CY9','PROF ASIG. "C"',0,0 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'JARAMILLO HEREDIA%');
UPDATE maestros SET rfc='JAHE920711CY9', categoria='PROF ASIG. "C"'        WHERE nombre ILIKE 'JARAMILLO HEREDIA%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'LOPEZ LOPEZ DANTE ALIGHIERI','LOLD540121T60','PROF TIT. "C" T/C',40,30 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'LOPEZ LOPEZ%');
UPDATE maestros SET rfc='LOLD540121T60', categoria='PROF TIT. "C" T/C'     WHERE nombre ILIKE 'LOPEZ LOPEZ%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'LOPEZ MAGAÑA SANDRA','LOMS690711FS1','PROF ASIG. "C"',0,0 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'LOPEZ MAGAÑA%');
UPDATE maestros SET rfc='LOMS690711FS1', categoria='PROF ASIG. "C"'        WHERE nombre ILIKE 'LOPEZ MAGAÑA%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'LUGO OROPEZA DIANA AMPARO','LUOD681221DB3','PROF TIT. "C" 3/4',30,22 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'LUGO OROPEZA%');
UPDATE maestros SET rfc='LUOD681221DB3', categoria='PROF TIT. "C" 3/4'     WHERE nombre ILIKE 'LUGO OROPEZA%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'LUNA RODRIGUEZ JANETH AGLAEE','LURJ790911EM3','PROF TIT. "A" 3/4',30,22 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'LUNA RODRIGUEZ%');
UPDATE maestros SET rfc='LURJ790911EM3', categoria='PROF TIT. "A" 3/4'     WHERE nombre ILIKE 'LUNA RODRIGUEZ%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'LUNA TORRES NORMA IRAIDA','LUTN671214AS9','PROF TIT. "C" T/C',40,30 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'LUNA TORRES%');
UPDATE maestros SET rfc='LUTN671214AS9', categoria='PROF TIT. "C" T/C'     WHERE nombre ILIKE 'LUNA TORRES%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'MARTINEZ BRINGAS MARTHA ISABEL','MABM6708285G7','PROF TIT. "B" 3/4',30,22 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'MARTINEZ BRINGAS%');
UPDATE maestros SET rfc='MABM6708285G7', categoria='PROF TIT. "B" 3/4'     WHERE nombre ILIKE 'MARTINEZ BRINGAS%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'MARTINEZ CASTRO RICARDO NOE','MACR731017RS2','PROF ASIG. "C"',0,0 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'MARTINEZ CASTRO%');
UPDATE maestros SET rfc='MACR731017RS2', categoria='PROF ASIG. "C"'        WHERE nombre ILIKE 'MARTINEZ CASTRO%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'MARQUEZ MUÑOZ JOSE OLIVERIO','MAMX611015J72','PROF TIT. "B" T/C',40,30 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'MARQUEZ MUÑOZ%');
UPDATE maestros SET rfc='MAMX611015J72', categoria='PROF TIT. "B" T/C'     WHERE nombre ILIKE 'MARQUEZ MUÑOZ%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'MEDINA DELGADO MARCO ANTONIO','MEDM8607111U3','PROF ASOC. "B" 3/4',30,22 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'MEDINA DELGADO%');
UPDATE maestros SET rfc='MEDM8607111U3', categoria='PROF ASOC. "B" 3/4'    WHERE nombre ILIKE 'MEDINA DELGADO%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'MENDIOLA TEJADA GLENDA','METG831205K13','PROF ASIG. "B"',0,0 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'MENDIOLA TEJADA%');
UPDATE maestros SET rfc='METG831205K13', categoria='PROF ASIG. "B"'        WHERE nombre ILIKE 'MENDIOLA TEJADA%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'MOLANO AGADO ELVA','MOAE6704133Y1','PROF TIT. "C" T/C',40,30 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'MOLANO AGADO%');
UPDATE maestros SET rfc='MOAE6704133Y1', categoria='PROF TIT. "C" T/C'     WHERE nombre ILIKE 'MOLANO AGADO%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'MORALES MUÑOZ ARTURO','MOMA660414TY8','PROF ASIG. "C"',0,0 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'MORALES MUÑOZ%');
UPDATE maestros SET rfc='MOMA660414TY8', categoria='PROF ASIG. "C"'        WHERE nombre ILIKE 'MORALES MUÑOZ%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'MORALES MIRANDA YOLANDA','MOMY710708IF1','PROF ASIG. "C"',0,0 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'MORALES MIRANDA%');
UPDATE maestros SET rfc='MOMY710708IF1', categoria='PROF ASIG. "C"'        WHERE nombre ILIKE 'MORALES MIRANDA%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'MOLANO RUEDA HECTOR VENTURA','MORH840603J11','PROF ASIG. "C"',0,0 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'MOLANO RUEDA%');
UPDATE maestros SET rfc='MORH840603J11', categoria='PROF ASIG. "C"'        WHERE nombre ILIKE 'MOLANO RUEDA%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'MONTERRUBIO SANTOS KARLA MARIA','MOSK8401197I7','PROF ASOC. "A" 1/2',20,16 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'MONTERRUBIO SANTOS%');
UPDATE maestros SET rfc='MOSK8401197I7', categoria='PROF ASOC. "A" 1/2'    WHERE nombre ILIKE 'MONTERRUBIO SANTOS%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'MUÑOZ TREVIÑO RAYMUNDO','MUTR7307269X3','PROF ASIG. "C"',0,0 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'MUÑOZ TREVIÑO%');
UPDATE maestros SET rfc='MUTR7307269X3', categoria='PROF ASIG. "C"'        WHERE nombre ILIKE 'MUÑOZ TREVIÑO%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'NEIRA PARTIDA RUBI NOHEMI','NEPR970820EL8','PROF ASIG. "A"',0,0 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'NEIRA PARTIDA%');
UPDATE maestros SET rfc='NEPR970820EL8', categoria='PROF ASIG. "A"'        WHERE nombre ILIKE 'NEIRA PARTIDA%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'OLVERA FUERTE KARLA AIDEE','OEFK800528RDA','PROF ASOC. "C" 1/2',20,16 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'OLVERA FUERTE%');
UPDATE maestros SET rfc='OEFK800528RDA', categoria='PROF ASOC. "C" 1/2'    WHERE nombre ILIKE 'OLVERA FUERTE%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'ORTEGA GUERRERO ELVIA LIZETH','OEGE840807SL4','PROF ASOC. "C" 1/2',20,16 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'ORTEGA GUERRERO%');
UPDATE maestros SET rfc='OEGE840807SL4', categoria='PROF ASOC. "C" 1/2'    WHERE nombre ILIKE 'ORTEGA GUERRERO%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'ORTIZ SALINAS DELFINA MADHAI','OISD810421CA2','PROF ASIG. "C"',0,0 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'ORTIZ SALINAS%');
UPDATE maestros SET rfc='OISD810421CA2', categoria='PROF ASIG. "C"'        WHERE nombre ILIKE 'ORTIZ SALINAS%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'PEREZ FLORES JUVENTINO','PEFJ550911H90','PROF TIT. "A" 3/4',30,22 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'PEREZ FLORES%');
UPDATE maestros SET rfc='PEFJ550911H90', categoria='PROF TIT. "A" 3/4'     WHERE nombre ILIKE 'PEREZ FLORES%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'PEREZ GARZA MARITZA','PEGM8308267Q0','PROF ASOC. "A" 1/2',20,16 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'PEREZ GARZA MARITZA%');
UPDATE maestros SET rfc='PEGM8308267Q0', categoria='PROF ASOC. "A" 1/2'    WHERE nombre ILIKE 'PEREZ GARZA MARITZA%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'PEREZ GARZA PEDRO ALBERTO','PEGP800912TX4','PROF ASIG. "C"',0,0 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'PEREZ GARZA PEDRO%');
UPDATE maestros SET rfc='PEGP800912TX4', categoria='PROF ASIG. "C"'        WHERE nombre ILIKE 'PEREZ GARZA PEDRO%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'PEREZ LIMAS BRENDA ELENA','PELB740530J95','PROF TIT. "C" T/C',40,30 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'PEREZ LIMAS%');
UPDATE maestros SET rfc='PELB740530J95', categoria='PROF TIT. "C" T/C'     WHERE nombre ILIKE 'PEREZ LIMAS%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'PECINA MORENO ROSA ELIA','PEMR740711QA1','PROF ASIG. "B"',0,0 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'PECINA MORENO%');
UPDATE maestros SET rfc='PEMR740711QA1', categoria='PROF ASIG. "B"'        WHERE nombre ILIKE 'PECINA MORENO%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'PEREZ PONCE KENIA','PEPK7405291G1','PROF TIT. "C" 3/4',30,22 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'PEREZ PONCE%');
UPDATE maestros SET rfc='PEPK7405291G1', categoria='PROF TIT. "C" 3/4'     WHERE nombre ILIKE 'PEREZ PONCE%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'PERALES TREJO KARLA','PETK761005PB2','PROF ASOC. "A" T/C',40,30 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'PERALES TREJO%');
UPDATE maestros SET rfc='PETK761005PB2', categoria='PROF ASOC. "A" T/C'    WHERE nombre ILIKE 'PERALES TREJO%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'RAMIREZ RODRIGUEZ NOE GUADALUPE','RARN7411108L9','PROF TIT. "C" T/C',40,30 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'RAMIREZ RODRIGUEZ%');
UPDATE maestros SET rfc='RARN7411108L9', categoria='PROF TIT. "C" T/C'     WHERE nombre ILIKE 'RAMIREZ RODRIGUEZ%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'RODRIGUEZ ESQUEDA JOSE ALFREDO','ROEA730925DP8','PROF TIT. "C" 3/4',30,22 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'RODRIGUEZ ESQUEDA%');
UPDATE maestros SET rfc='ROEA730925DP8', categoria='PROF TIT. "C" 3/4'     WHERE nombre ILIKE 'RODRIGUEZ ESQUEDA%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'RODRIGUEZ GAUCIN ALFREDO','ROGA570112J72','PROF TIT. "C" T/C',40,30 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'RODRIGUEZ GAUCIN%');
UPDATE maestros SET rfc='ROGA570112J72', categoria='PROF TIT. "C" T/C'     WHERE nombre ILIKE 'RODRIGUEZ GAUCIN%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'RODELA ROJAS HECTOR','RORH6405204L9','PROF ASIG. "C"',0,0 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'RODELA ROJAS%');
UPDATE maestros SET rfc='RORH6405204L9', categoria='PROF ASIG. "C"'        WHERE nombre ILIKE 'RODELA ROJAS%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'ROCHA SOLIS NELLY STEPHANIE','ROSN960808DP5','TEC. DOC. ASOC. A T/C',40,30 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'ROCHA SOLIS%');
UPDATE maestros SET rfc='ROSN960808DP5', categoria='TEC. DOC. ASOC. A T/C' WHERE nombre ILIKE 'ROCHA SOLIS%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'ROSAS VILLARREAL ANA LAURA','ROVA691112QN2','PROF ASOC. "C" 3/4',30,22 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'ROSAS VILLARREAL%');
UPDATE maestros SET rfc='ROVA691112QN2', categoria='PROF ASOC. "C" 3/4'    WHERE nombre ILIKE 'ROSAS VILLARREAL%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'RUIZ GONZALEZ VIRIDIANA','RUGV8410039R3','PROF ASIG. "C"',0,0 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'RUIZ GONZALEZ%');
UPDATE maestros SET rfc='RUGV8410039R3', categoria='PROF ASIG. "C"'        WHERE nombre ILIKE 'RUIZ GONZALEZ%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'SALINAS DIAZ ALFREDO JOEL','SADA831001981','PROF TIT. "A" T/C',40,30 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'SALINAS DIAZ%');
UPDATE maestros SET rfc='SADA831001981', categoria='PROF TIT. "A" T/C'     WHERE nombre ILIKE 'SALINAS DIAZ%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'SANCHEZ GARCIA JOSE FRANCISCO','SAGF770201A37','PROF ASIG. "C"',0,0 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'SANCHEZ GARCIA%');
UPDATE maestros SET rfc='SAGF770201A37', categoria='PROF ASIG. "C"'        WHERE nombre ILIKE 'SANCHEZ GARCIA%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'SANDOVAL LARA MARIA GUADALUPE','SALG690704Q10','PROF TIT. "C" 3/4',30,22 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'SANDOVAL LARA%');
UPDATE maestros SET rfc='SALG690704Q10', categoria='PROF TIT. "C" 3/4'     WHERE nombre ILIKE 'SANDOVAL LARA%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'SANCHEZ LOPEZ KERIME','SALK840125J32','PROF ASOC. "C" 1/2',20,16 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'SANCHEZ LOPEZ%');
UPDATE maestros SET rfc='SALK840125J32', categoria='PROF ASOC. "C" 1/2'    WHERE nombre ILIKE 'SANCHEZ LOPEZ%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'SANCHEZ PESQUEDA JUAN ANDRES','SAPJ8112273B3','PROF ASOC. "A" 3/4',30,22 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'SANCHEZ PESQUEDA%');
UPDATE maestros SET rfc='SAPJ8112273B3', categoria='PROF ASOC. "A" 3/4'    WHERE nombre ILIKE 'SANCHEZ PESQUEDA%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'SALINAS RODRIGUEZ CYNTHIA ELENA','SARC800409HG4','PROF ASOC. "A" 1/2',20,16 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'SALINAS RODRIGUEZ%');
UPDATE maestros SET rfc='SARC800409HG4', categoria='PROF ASOC. "A" 1/2'    WHERE nombre ILIKE 'SALINAS RODRIGUEZ%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'SEGURA CASTILLA JOSE ANGEL','SECA850506AN4','PROF ASOC. "B" 1/2',20,16 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'SEGURA CASTILLA%');
UPDATE maestros SET rfc='SECA850506AN4', categoria='PROF ASOC. "B" 1/2'    WHERE nombre ILIKE 'SEGURA CASTILLA%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'SIFUENTES CERVANTES JOSE','SICJ5904261S4','PROF TIT. "B" T/C',40,30 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'SIFUENTES CERVANTES%');
UPDATE maestros SET rfc='SICJ5904261S4', categoria='PROF TIT. "B" T/C'     WHERE nombre ILIKE 'SIFUENTES CERVANTES%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'SOTO SANCHEZ BEATRIZ','SOSB711018FU3','PROF TIT. "B" 3/4',30,22 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'SOTO SANCHEZ%');
UPDATE maestros SET rfc='SOSB711018FU3', categoria='PROF TIT. "B" 3/4'     WHERE nombre ILIKE 'SOTO SANCHEZ%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'TREVIÑO MERCADO ALBERTO','TEMA750707L67','PROF TIT. "C" 3/4',30,22 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'TREVIÑO MERCADO%');
UPDATE maestros SET rfc='TEMA750707L67', categoria='PROF TIT. "C" 3/4'     WHERE nombre ILIKE 'TREVIÑO MERCADO%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'TOVAR SEGURA AMERICO','TOSA731204CX7','PROF ASIG. "C"',0,0 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'TOVAR SEGURA%');
UPDATE maestros SET rfc='TOSA731204CX7', categoria='PROF ASIG. "C"'        WHERE nombre ILIKE 'TOVAR SEGURA%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'TRUJILLO GARCIA MYRIAM LIZETH','TUGM790806IW0','PROF TIT. "B" 3/4',30,22 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'TRUJILLO GARCIA%');
UPDATE maestros SET rfc='TUGM790806IW0', categoria='PROF TIT. "B" 3/4'     WHERE nombre ILIKE 'TRUJILLO GARCIA%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'VAZQUEZ HERRERA JAZMIN LIZETH','VAHJ810706GX2','PROF TIT. "C" 1/2',20,16 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'VAZQUEZ HERRERA%');
UPDATE maestros SET rfc='VAHJ810706GX2', categoria='PROF TIT. "C" 1/2'     WHERE nombre ILIKE 'VAZQUEZ HERRERA%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'VAZQUEZ ROBLES ESTEBAN','VARE5409121H1','PROF TIT. "C" T/C',40,30 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'VAZQUEZ ROBLES%');
UPDATE maestros SET rfc='VARE5409121H1', categoria='PROF TIT. "C" T/C'     WHERE nombre ILIKE 'VAZQUEZ ROBLES%';

INSERT INTO maestros (id,nombre,rfc,categoria,hrs_nom,hrs_carga) SELECT gen_random_uuid(),'VERBER WALLE MAYRA ALEJANDRA','VEWM790729UC0','PROF TIT. "B" 3/4',30,22 WHERE NOT EXISTS (SELECT 1 FROM maestros WHERE nombre ILIKE 'VERBER WALLE%');
UPDATE maestros SET rfc='VEWM790729UC0', categoria='PROF TIT. "B" 3/4'     WHERE nombre ILIKE 'VERBER WALLE%';

