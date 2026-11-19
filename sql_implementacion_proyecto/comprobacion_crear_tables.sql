USE practica;

-- =========================================================================
-- BATERÍA DE PRUEBAS NEGATIVAS (TODAS DEBEN DAR ERROR AL EJECUTARSE)
-- =========================================================================

-- PRUEBA 1: Romper la RN04 (Trigger de misión activa)
-- Intentamos matricular en Escuela de Oficios a Amara (OID = 9), que sigue apadrinada (fechaFinApadrinado = NULL).
-- RESULTADO ESPERADO: Error 1644 -> "RN04: La persona ya está recibiendo ayuda económica activa y no puede abrir otra nueva misión."
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


-- PRUEBA 6: Romper la RN02 (Un único contrato vigente por apadrinado)
-- Intentamos abrir un segundo contrato vigente (fecha_fin = NULL) para Amara (OID = 9), que ya tiene activo el contrato 1601.
-- RESULTADO ESPERADO: Error 1644 -> "RN02: Este apadrinado ya tiene un contrato vigente con un benefactor."
INSERT INTO ContratoPadrino (OID, aportacion, fecha_inicio, fecha_fin, OID_Be, OID_A) 
VALUES (9995, 40.00, '2026-11-19', NULL, 7, 9);


-- PRUEBA 7: Romper la RN04 inversa (Solapamiento de ayuda económica con otros roles)
-- Intentamos registrar como Empleado a Akossiwa (OID = 12), que actualmente es estudiante becada activa.
-- RESULTADO ESPERADO: Error 1644 -> "RN04: Una persona con ayuda económica activa no puede ser Empleado."
INSERT INTO Empleado (OID, NIF, correo, telefono, rol) 
VALUES (12, 'TG-0000000X', 'akossiwa.emp@atachiarare.org', '+22890000000', 'Administrativa');


-- PRUEBA 8: Romper la RN01 (Límite de 18 años para apadrinamiento)
-- Intentamos apadrinar hoy a Edem (OID = 13), nacido en 2004 (22 años en 2026).
-- RESULTADO ESPERADO: Error 1644 -> "RN01: La misión de apadrinamiento es solo para menores de 18 años."
INSERT INTO Apadrinado (OID, fechaFinApadrinado, localidad, nombreTutor, telefonoTutor, emailTutor, OID_AM) 
VALUES (13, NULL, 'Lomé', 'Tutor Prueba', '+22890001111', 'tutor@test.tg', 103);


-- PRUEBA 9: Romper la RN04 en actualización (Reactivar misión antigua en UPDATE)
-- Intentamos reabrir el apadrinamiento de Kofi (OID = 11) poniendo su fechaFinApadrinado a NULL cuando ya es Estudiante_B activo.
-- RESULTADO ESPERADO: Error 1644 -> "RN04: No se puede reactivar el apadrinamiento; la persona ya tiene otra ayuda activa."
UPDATE Apadrinado 
SET fechaFinApadrinado = NULL 
WHERE OID = 11;