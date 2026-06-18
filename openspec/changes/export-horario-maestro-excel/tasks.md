## 1. Plantilla y dependencias

- [x] 1.1 Definir la plantilla Excel base que se usará para la exportación
- [x] 1.2 Integrar SheetJS en la SPA sin romper la carga actual

## 2. Modelo de exportación

- [x] 2.1 Crear el modelo intermedio del horario por maestro desde `horario`, `grupos` y `maestros`
- [x] 2.2 Definir el mapeo de turno, franja y día a celdas Excel
- [x] 2.3 Incluir datos del maestro, carga académica y bloques aprobados en el modelo

## 3. UI de Horario Maestro

- [x] 3.1 Agregar una acción visible para exportar Excel en la vista de Horario Maestro
- [x] 3.2 Conectar la acción con la generación y descarga del archivo `.xlsx`

## 4. Validación manual

- [ ] 4.1 Probar exportación con un maestro de turno matutino
- [ ] 4.2 Probar exportación con un maestro de turno vespertino
- [ ] 4.3 Verificar que la impresión actual siga funcionando sin cambios
- [ ] 4.4 Revisar que el archivo conserve el formato institucional y se abra correctamente en Excel