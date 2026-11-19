USE practica;

-- =========================================================================
-- BATERÍA DE PRUEBAS NEGATIVAS (TODAS DEBEN DAR ERROR AL EJECUTARSE)
-- =========================================================================

-- PRUEBA 1: Romper la RN04 (Trigger de misión activa)
-- Intentamos matricular en Escuela de Oficios a Amara (OID = 9), que sigue apadrinada (fechaFinApadrinado = NULL).
-- RESULTADO ESPERADO: Error 1644 -> "RN04: La persona ya está recibiendo ayuda económica activa..."
INSERT INTO Estudiante_O (OID, correo, telefono, fecha_inicio, fecha_fin, OID_EO) 
VALUES (9, 'amara.error@oficios.tg', '+22899999999', '2026-11-19', NULL, 101);


-- PRUEBA 2: Romper el Arco Exclusivo Triple en ContieneAProyecto
-- Intentamos asociar el Proyecto 1101 a DOS misiones a la vez (Escuela de Oficios 101 y Becados 102).
-- RESULTADO ESPERADO: Error 3819 -> Check constraint 'contieneaproyecto_chk_1' is violated.
INSERT INTO ContieneAProyecto (OID, OID_P, OID_EO, OID_B, OID_AM) 
VALUES (9991, 1101, 101, 102, NULL);


-- PRUEBA 3: Romper el Arco Exclusivo Doble en ContratoTrabajador
-- Intentamos crear un contrato sin asignar NINGUNA misión (ambos OID a NULL).
-- RESULTADO ESPERADO: Error 3819 -> Check constraint 'contratotrabajador_chk_1' is violated.
INSERT INTO ContratoTrabajador (OID, sueldo, fecha_inicio, fecha_fin, OID_T, OID_EO, OID_AM) 
VALUES (9992, 500.00, '2026-11-19', NULL, 1, NULL, NULL);


-- PRUEBA 4: Romper la RN03 (Rango de notas entre 0 y 10)
-- Intentamos poner un 12.50 en NotaOficios.
-- RESULTADO ESPERADO: Error 3819 -> Check constraint 'notaoficios_chk_1' is violated.
INSERT INTO NotaOficios (OID, nota, OID_AO, OID_EO) 
VALUES (9993, 12.50, 301, 13);


-- PRUEBA 5: Romper el ENUM de valoración en AccionesMarketing
-- Intentamos meter un texto que no existe en el enumerado del diagrama.
-- RESULTADO ESPERADO: Error 1265 -> Data truncated for column 'valoracion_E'.
INSERT INTO AccionesMarketing (OID, hora, fecha, contenido, metodoComunicacion, valoracion_E, OID_E, OID_Be) 
VALUES (9994, '12:00:00', '2026-11-19', 'Prueba fallo', 'Email', 'EXCELENTE', 4, 6);