USE practica;

-- ==========================================
-- NIVEL 1: MISIONES 
-- ==========================================
INSERT INTO Escuela_Oficios (OID, Titulo, Localidad, Descripcion) VALUES
(101, 'Centro Politécnico Atachiarare', 'Lomé', 'Formación profesional en mecánica, informática, electricidad y albañilería para jóvenes mayores de edad.'),
(104, 'Escuela Técnica Rural del Norte', 'Kara', 'Formación práctica en agricultura sostenible, ganadería y fontanería para jóvenes de la región de Kara.');
 
INSERT INTO Becados (OID, Titulo, Localidad, Descripcion) VALUES
(102, 'Programa Impulso Universitario Togo', 'Kara', 'Becas de estudio superior y manutención para antiguos apadrinados.'),
(105, 'Becas de Grado Superior Lomé', 'Lomé', 'Ayudas económicas para alojamiento, matrícula y material universitario en la capital.');

INSERT INTO Apadrinamiento (OID, Titulo, Localidad, Descripcion) VALUES
(103, 'Apadrinamiento Escolar Infantil', 'Kpalimé', 'Cuota mensual para escolarización básica, material y alimentación de menores de 18 años.'),
(106, 'Apadrinamiento Primaria Sokodé', 'Sokodé', 'Programa de apoyo escolar, comedor y seguimiento sanitario para niños en edad escolar en Sokodé.');

-- ==========================================
-- NIVEL 2: PERSONAS BASE (TODAS)
-- ==========================================
INSERT INTO Persona (OID, nombre, apellidos, fechaNacimiento) VALUES
-- Trabajadores (1 - 3, 15 - 19)
(1, 'Kwame', 'Nkrumah Abalo', '1982-04-15'),
(2, 'Afi', 'Koffi Mensah', '1988-09-22'),
(3, 'Kodjo', 'Toure Bassabi', '1979-11-03'),
(15, 'Fatou', 'Diop', '1992-05-14'),
(16, 'Koffi', 'Salami', '1985-11-20'),
(17, 'Komlan', 'Adjamagbo', '1984-07-08'),
(18, 'Abla', 'Tchagnao', '1990-01-25'),
(19, 'Kokou', 'Bawa', '1977-03-11'),
-- Empleados España (4 - 5, 20)
(4, 'Elena', 'Gómez Navarro', '1990-02-14'),
(5, 'Carlos', 'Martínez Ruiz', '1985-07-30'),
(20, 'Marta', 'Jiménez López', '1993-06-18'),
-- Benefactores (6 - 8, 21 - 24)
(6, 'Lucía', 'Fernández Vega', '1975-12-10'),
(7, 'Javier', 'Sánchez Ortiz', '1968-05-19'),
(8, 'Fundación', 'Horizonte Sur S.L.', '2001-01-01'),
(21, 'Antonio', 'Ruiz Morales', '1972-09-04'),
(22, 'Sofía', 'Delgado Castro', '1981-04-27'),
(23, 'Cooperativa', 'Andalucía Solidaria', '2005-03-15'),
(24, 'Miguel', 'Torres Herrera', '1965-11-12'),
-- Apadrinados (9 - 11, 25 - 28)
(9, 'Amara', 'Diallo Kossi', '2014-06-12'),
(10, 'Yao', 'Agbeko Lawson', '2012-03-25'),
(11, 'Kofi', 'Mensah Gnassingbe', '2006-05-10'), -- Histórico apadrinado, ahora Becado
(25, 'Essi', 'Kouma Agbo', '2015-08-19'),
(26, 'Kossi', 'Ameganvi', '2011-11-02'),
(27, 'Amina', 'Ouro-Sama', '2013-02-14'),
(28, 'Yawa', 'Tchedre', '2016-09-30'),
-- Estudiantes Becados (12, 29 - 30) y Oficios (13 - 14, 31 - 34)
(12, 'Akossiwa', 'Amouzou Tchalla', '2005-08-19'),
(13, 'Edem', 'Sodji Kpegba', '2004-11-30'),
(14, 'Mawuli', 'Ahiagba Dossou', '2003-01-20'),
(29, 'Sena', 'Gbegnon', '2004-04-09'),
(30, 'Femi', 'Akpalo', '2005-12-01'),
(31, 'Dodzi', 'Kuwonu', '2003-07-17'),
(32, 'Kafui', 'Amedegnato', '2004-02-28'),
(33, 'Tete', 'Lawson-Body', '2002-10-05'),
(34, 'Enyonam', 'Atayi', '2005-05-22');

-- ==========================================
-- NIVEL 3: BENEFACTORES, EMPLEADOS, APADRINADOS Y TRABAJADORES
-- ==========================================
INSERT INTO Benefactor (OID, NIF, telefono, horasPosiblesLlamadas, correo, individuo, cuenta_bancaria) VALUES
(5, '28765432M', '+34600112233', '18:00 - 20:30', 'carlos.martinez@gmail.com', TRUE, 'ES9121000418450200051332'),
(6, '30987654L', '+34611223344', '10:00 - 13:00', 'lucia.fvega@hotmail.com', TRUE, 'ES7600491500051234567892'),
(7, '45123987K', '+34622334455', '16:00 - 19:00', 'javier.sanchez@empresa.es', TRUE, 'ES1001822370410201567890'),
(8, 'G41998877', '+34954112233', '09:00 - 14:00', 'contacto@horizontesur.org', FALSE, 'ES3300810658100001234567'),
(21, '31445566R', '+34644556677', '17:00 - 20:00', 'antonio.ruiz@correo.es', TRUE, 'ES4521000813610123456789'),
(22, '48990011S', '+34655667788', '11:00 - 13:30', 'sofia.delgado@gmail.com', TRUE, 'ES1200491500059876543210'),
(23, 'F41887766', '+34954998877', '09:30 - 13:30', 'info@andaluciasolidaria.org', FALSE, 'ES8801822370410209988776'),
(24, '28112233T', '+34666778899', '19:00 - 21:00', 'miguel.torres@yahoo.es', TRUE, 'ES6000810658100005544332');

INSERT INTO Empleado (OID, NIF, correo, telefono, rol) VALUES
(4, '29456123P', 'elena.gomez@atachiarare.org', '+34633445566', 'Coordinadora de Apadrinamientos'),
(5, '28765432M', 'carlos.martinez@atachiarare.org', '+34600112233', 'Tesorero y Contabilidad'),
(20, '30223344W', 'marta.jimenez@atachiarare.org', '+34677889900', 'Responsable de Marketing y Comunicación');

INSERT INTO Apadrinado (OID, fechaFinApadrinado, localidad, nombreTutor, telefonoTutor, emailTutor, OID_AM) VALUES
(9, NULL, 'Kpalimé', 'Mamadou Diallo', '+22890112233', 'mamadou.diallo@togo.tg', 103),
(10, '2030-03-25', 'Kpalimé', 'Grace Lawson', '+22890445566', 'grace.lawson@togo.tg', 103),
(11, '2024-05-10', 'Kpalimé', 'Samuel Gnassingbe', '+22890778899', 'samuel.g@togo.tg', 103),
(25, NULL, 'Kpalimé', 'Kossiwa Agbo', '+22890123456', 'kossiwa.agbo@togo.tg', 103),
(26, '2029-11-02', 'Sokodé', 'Yao Ameganvi', '+22890654321', 'yao.ameganvi@togo.tg', 106),
(27, NULL, 'Sokodé', 'Issifou Ouro-Sama', '+22890771122', 'issifou.os@togo.tg', 106),
(28, NULL, 'Sokodé', 'Mariama Tchedre', '+22890882233', 'mariama.t@togo.tg', 106);

INSERT INTO Trabajador (OID, NIF, correo, telefono, rol) VALUES
(1, 'TG-8849201A', 'kwame.nkrumah@atachiarare.org', '+22893111222', 'Profesor'),
(2, 'TG-7738192B', 'afi.koffi@atachiarare.org', '+22893333444', 'Profesor'),
(3, 'TG-6627183C', 'kodjo.toure@atachiarare.org', '+22893555666', 'Profesor'),
(15, 'TG-5544332D', 'fatou.diop@atachiarare.org', '+22899887766', 'Administrativa'),
(16, 'TG-1122334E', 'koffi.salami@atachiarare.org', '+22899775533', 'Personal de Limpieza'),
(17, 'TG-4455667F', 'komlan.adjamagbo@atachiarare.org', '+22893777888', 'Profesor'),
(18, 'TG-3344558G', 'abla.tchagnao@atachiarare.org', '+22893999000', 'Profesor'),
(19, 'TG-2233449H', 'kokou.bawa@atachiarare.org', '+22899664422', 'Conserje y Mantenimiento');

-- ==========================================
-- NIVEL 4: CONTRATOS (APADRINADOS Y TRABAJADORES)
-- ==========================================
INSERT INTO ContratoPadrino (OID, aportacion, fecha_inicio, fecha_fin, OID_Be, OID_A) VALUES
-- Vigentes
(1601, 30.00, '2022-01-01', NULL, 6, 9),
(1602, 35.00, '2021-09-01', NULL, 5, 10),
(1604, 30.00, '2024-01-15', NULL, 21, 25),
(1605, 40.00, '2023-06-01', NULL, 22, 26),
(1606, 35.00, '2025-02-01', NULL, 7, 27),
(1607, 30.00, '2025-09-01', NULL, 24, 28),
-- Históricos (finalizados, útiles para historial contractual de benefactores y cambios de padrino)
(1603, 30.00, '2018-05-10', '2024-05-10', 7, 11),
(1608, 25.00, '2020-01-01', '2021-12-31', 21, 9),
(1609, 30.00, '2021-01-01', '2023-05-31', 6, 26);

INSERT INTO ContratoTrabajador (OID, sueldo, fecha_inicio, fecha_fin, OID_T, OID_EO, OID_AM) VALUES
-- Vigentes
(901, 450.00, '2023-01-01', NULL, 1, 101, NULL),
(902, 420.00, '2023-03-15', NULL, 2, NULL, 103),
(903, 460.00, '2024-02-01', '2026-12-31', 3, 101, NULL),
(904, 400.00, '2025-01-01', NULL, 15, 101, NULL),
(905, 350.00, '2025-02-15', NULL, 16, NULL, 103),
(906, 440.00, '2024-09-01', NULL, 17, 104, NULL),
(907, 430.00, '2024-09-01', NULL, 18, NULL, 106),
(908, 360.00, '2025-01-10', NULL, 19, 104, NULL),
-- Históricos (finalizados, útiles para historial contractual de trabajadores)
(909, 390.00, '2020-01-01', '2022-12-31', 1, 101, NULL),
(910, 380.00, '2021-03-01', '2023-02-28', 2, NULL, 103),
(911, 410.00, '2022-09-01', '2024-08-31', 17, 101, NULL);

-- ==========================================
-- NIVEL 5: CURSOS, ASIGNATURAS Y ESTUDIANTES (O/B)
-- ==========================================
INSERT INTO Curso (OID, Titulo, escuelaOficio) VALUES
(201, 'Técnico en Informática y Redes', 101),
(202, 'Mecánica Automotriz y Agrícola', 101),
(203, 'Instalaciones Eléctricas y Solares', 101),
(204, 'Agricultura Sostenible y Riego', 104),
(205, 'Fontanería y Saneamiento Rural', 104);

INSERT INTO Estudiante_B (OID, Correo, Telefono, QueEstudia, Destino, fecha_inicio, fecha_fin, becado) VALUES
(11, 'kofi.mensah@univ-kara.tg', '+22891001122', 'Enfermería', 'Universidad de Kara', '2024-09-01', NULL, 102),
(12, 'akossiwa.amouzou@univ-lome.tg', '+22891334455', 'Ingeniería Agronómica', 'Universidad de Lomé', '2023-09-15', '2027-06-30', 102),
(29, 'sena.gbegnon@univ-lome.tg', '+22891556677', 'Arquitectura Técnica', 'Universidad de Lomé', '2024-09-10', '2028-06-30', 105),
(30, 'femi.akpalo@univ-lome.tg', '+22891778899', 'Administración de Empresas', 'Universidad de Lomé', '2025-09-01', NULL, 105);

INSERT INTO AsignaturaOficios (OID, titulo) VALUES
(301, 'Sistemas Operativos y Hardware'),
(302, 'Programación Básica'),
(303, 'Motores Diésel y Maquinaria'),
(304, 'Electricidad Industrial'),
(305, 'Cultivos de Secano y Fertilización'),
(306, 'Instalaciones Hidráulicas');

INSERT INTO ContieneAAsignatura (OID_CA, OID_C, OID_AO) VALUES
(1, 201, 301),
(2, 201, 302),
(3, 202, 303),
(4, 203, 304),
(5, 204, 305),
(6, 205, 306);

INSERT INTO Estudiante_O (OID, correo, telefono, fecha_inicio, fecha_fin, OID_EO) VALUES
(13, 'edem.sodji@oficios.tg', '+22892112233', '2025-10-01', NULL, 101),
(14, 'mawuli.ahiagba@oficios.tg', '+22892445566', '2025-10-01', '2027-07-15', 101),
(31, 'dodzi.kuwonu@oficios.tg', '+22892556677', '2025-10-01', NULL, 101),
(32, 'kafui.amedegnato@oficios.tg', '+22892667788', '2025-10-01', '2027-07-15', 101),
(33, 'tete.lawson@oficios.tg', '+22892778899', '2025-10-01', NULL, 104),
(34, 'enyonam.atayi@oficios.tg', '+22892889900', '2025-10-01', '2027-07-15', 104);

-- ==========================================
-- NIVEL 6: DOCENCIA, NOTAS Y SUELDOS PAGADOS
-- ==========================================
INSERT INTO NotaOficios (OID, nota, OID_AO, OID_EO) VALUES
(401, 8.75, 301, 13),
(402, 7.50, 302, 13),
(403, 9.20, 303, 14),
(404, 6.80, 301, 31),
(405, 8.10, 302, 31),
(406, 7.90, 304, 32),
(407, 8.50, 303, 32),
(408, 9.00, 305, 33),
(409, 7.40, 306, 33),
(410, 8.20, 305, 34),
(411, 8.90, 306, 34);

INSERT INTO TrabajaEnOficios (OID, OID_AO, OID_T) VALUES
(501, 301, 1),
(502, 302, 1),
(503, 303, 3),
(504, 304, 3),
(505, 305, 17),
(506, 306, 17);

INSERT INTO AsignaturaApadrinado (OID, titulo) VALUES
(601, 'Matemáticas y Cálculo'),
(602, 'Lengua Francesa y Lectura'),
(603, 'Ciencias Naturales'),
(604, 'Historia y Geografía');

INSERT INTO TrabajaEnApadrinado (OID, OID_AP, OID_T) VALUES
(701, 601, 2),
(702, 602, 2),
(703, 603, 18),
(704, 604, 18);

INSERT INTO NotaApadrinado (OID, nota, OID_A, OID_AP) VALUES
(801, 9.00, 9, 601),
(802, 8.25, 9, 602),
(803, 6.80, 10, 601),
(804, 7.50, 10, 602),
(805, 8.60, 25, 601),
(806, 9.10, 25, 602),
(807, 7.20, 26, 603),
(808, 8.00, 26, 604),
(809, 8.80, 27, 603),
(810, 7.90, 27, 604),
(811, 9.40, 28, 603),
(812, 8.50, 28, 604);

-- Nóminas en varios meses (2025 y 2026) para pruebas de balance mensual y anual
INSERT INTO SueldoPagado (OID, cantidad, fecha, OID_T, OID_EO, OID_AM) VALUES
-- Octubre 2026
(1001, 450.00, '2026-10-31', 1, 101, NULL),
(1002, 420.00, '2026-10-31', 2, NULL, 103),
(1003, 460.00, '2026-10-31', 3, 101, NULL),
(1004, 400.00, '2026-10-31', 15, 101, NULL),
(1005, 350.00, '2026-10-31', 16, NULL, 103),
(1006, 440.00, '2026-10-31', 17, 104, NULL),
(1007, 430.00, '2026-10-31', 18, NULL, 106),
(1008, 360.00, '2026-10-31', 19, 104, NULL),
-- Septiembre 2026
(1009, 450.00, '2026-09-30', 1, 101, NULL),
(1010, 420.00, '2026-09-30', 2, NULL, 103),
(1011, 460.00, '2026-09-30', 3, 101, NULL),
(1012, 440.00, '2026-09-30', 17, 104, NULL),
(1013, 430.00, '2026-09-30', 18, NULL, 106),
-- Diciembre 2025 (para comparativa anual)
(1014, 450.00, '2025-12-31', 1, 101, NULL),
(1015, 420.00, '2025-12-31', 2, NULL, 103);

-- ==========================================
-- NIVEL 7: PROYECTOS, PAGOS Y MARKETING
-- ==========================================
INSERT INTO Proyecto (OID, titulo, contenido, capitalEstimado, fecha_inicio, fecha_fin) VALUES
(1101, 'Aula Solar Informática Lomé', 'Instalación de placas solares y 20 equipos reacondicionados.', 15000.00, '2026-01-15', '2026-12-20'),
(1102, 'Comedor Escolar Kpalimé', 'Rehabilitación de cocina y suministro anual de alimentos.', 8500.00, '2026-03-01', NULL),
(1103, 'Pozo y Sistema de Riego Kara', 'Perforación de pozo con bomba solar para prácticas agrícolas.', 12000.00, '2026-02-01', '2026-11-30'),
(1104, 'Residencia Universitaria Kara', 'Adecuación de 10 habitaciones para estudiantes becados.', 20000.00, '2026-04-01', NULL),
(1105, 'Biblioteca y Material Escolar Sokodé', 'Creación de biblioteca infantil y lote de libros de texto.', 6000.00, '2026-05-15', '2026-12-15');

INSERT INTO ContieneAProyecto (OID, OID_P, OID_EO, OID_B, OID_AM) VALUES
(1201, 1101, 101, NULL, NULL),
(1202, 1102, NULL, NULL, 103),
(1203, 1103, 104, NULL, NULL),
(1204, 1104, NULL, 102, NULL),
(1205, 1105, NULL, NULL, 106);

INSERT INTO ActividadProyecto (OID, titulo, descripcion, coste, fecha_inicio, fecha_fin) VALUES
(1301, 'Compra de paneles fotovoltaicos', 'Adquisición e importación de 12 paneles solares.', 6500.00, '2026-02-01', '2026-03-15'),
(1302, 'Montaje de red eléctrica e internet', 'Cableado estructurado del aula.', 3200.00, '2026-04-01', '2026-05-10'),
(1303, 'Equipamiento de cocina industrial', 'Fogones de gas y menaje para 150 niños.', 4100.00, '2026-03-10', '2026-04-20'),
(1304, 'Perforación y entubado de pozo', 'Excavación a 60 metros y tubería de PVC.', 5800.00, '2026-03-01', '2026-04-15'),
(1305, 'Instalación de bomba solar', 'Bomba sumergible y depósito elevado de 5000L.', 3400.00, '2026-05-01', '2026-06-10'),
(1306, 'Mobiliario para habitaciones', 'Literas, escritorios y armarios para becados.', 7500.00, '2026-05-15', '2026-07-01'),
(1307, 'Compra de libros y estanterías', 'Lote de 500 libros de primaria y mobiliario de lectura.', 2800.00, '2026-06-01', '2026-07-20');

INSERT INTO ContieneAActividadesProyecto (OID, OID_P, OID_AP) VALUES
(1401, 1101, 1301),
(1402, 1101, 1302),
(1403, 1102, 1303),
(1404, 1103, 1304),
(1405, 1103, 1305),
(1406, 1104, 1306),
(1407, 1105, 1307);

INSERT INTO Aportacion_B (OID, cantidad, fecha, OID_P, OID_B) VALUES
(1501, 5000.00, '2026-01-20', 1101, 8),
(1502, 1200.00, '2026-02-10', 1101, 7),
(1503, 2500.00, '2026-03-05', 1102, 8),
(1504, 6000.00, '2026-02-18', 1103, 23),
(1505, 1500.00, '2026-04-12', 1103, 21),
(1506, 8000.00, '2026-04-25', 1104, 23),
(1507, 3000.00, '2026-05-20', 1105, 8),
(1508, 1000.00, '2026-06-15', 1105, 22),
(1509, 2000.00, '2026-10-10', 1101, 23);

-- Pagos de cuotas de apadrinamiento (varios meses para consultas mensuales/anuales)
INSERT INTO Pago (OID, cantidad, fecha, OID_Be) VALUES
-- Noviembre 2026
(1701, 30.00, '2026-11-01', 6),
(1702, 35.00, '2026-11-02', 5),
(1703, 30.00, '2026-11-03', 21),
(1704, 40.00, '2026-11-03', 22),
(1705, 35.00, '2026-11-04', 7),
(1706, 30.00, '2026-11-05', 24),
-- Octubre 2026
(1707, 30.00, '2026-10-01', 6),
(1708, 35.00, '2026-10-02', 5),
(1709, 30.00, '2026-10-03', 21),
(1710, 40.00, '2026-10-03', 22),
-- Diciembre 2025
(1711, 30.00, '2025-12-01', 6),
(1712, 35.00, '2025-12-02', 5);

INSERT INTO TienePago (OID, OID_Pa, OID_A) VALUES
(1801, 1701, 9),
(1802, 1702, 10),
(1803, 1703, 25),
(1804, 1704, 26),
(1805, 1705, 27),
(1806, 1706, 28),
(1807, 1707, 9),
(1808, 1708, 10),
(1809, 1709, 25),
(1810, 1710, 26),
(1811, 1711, 9),
(1812, 1712, 10);

INSERT INTO AccionesMarketing (OID, hora, fecha, contenido, metodoComunicacion, valoracion_E, OID_E, OID_Be) VALUES
(1901, '18:30:00', '2026-10-15', 'Llamada de seguimiento trimestral y envío de notas de Amara.', 'Teléfono', 'MUY_BIEN', 4, 6),
(1902, '11:15:00', '2026-10-20', 'Presentación de memoria económica del Aula Solar.', 'Videollamada', 'BIEN', 4, 8),
(1903, '17:00:00', '2026-11-05', 'Consulta sobre renovación de donación anual.', 'Correo Electrónico', 'NORMAL', 5, 7),
(1904, '18:00:00', '2026-11-08', 'Queja por retraso en el envío de la foto anual del apadrinado.', 'Teléfono', 'MAL', 20, 21),
(1905, '12:00:00', '2026-11-10', 'Incidencia con el recibo bancario duplicado en octubre.', 'Teléfono', 'MUY_MAL', 5, 22),
(1906, '10:30:00', '2026-11-12', 'Agradecimiento por aportación al proyecto de Pozo en Kara.', 'Videollamada', 'MUY_BIEN', 20, 23),
(1907, '19:30:00', '2026-11-15', 'Llamada de bienvenida y explicación de seguimiento escolar.', 'Teléfono', 'BIEN', 4, 24);

-- =========================================================================
-- AMPLIACIÓN DE DATOS: ENTIDADES CON APADRINADOS Y PADRINOS MULTI-CONTRATO
-- =========================================================================

-- 1. Nuevas personas (menores de 18 años para cumplir RN01)
INSERT INTO Persona (OID, nombre, apellidos, fechaNacimiento) VALUES
(35, 'Afiavi', 'Kouassi', '2015-04-18'),
(36, 'Komla', 'Tossou', '2013-10-05'),
(37, 'Mawuena', 'Adjei', '2016-01-22');

-- 2. Alta como apadrinados activos en las misiones de Kpalimé (103) y Sokodé (106)
INSERT INTO Apadrinado (OID, fechaFinApadrinado, localidad, nombreTutor, telefonoTutor, emailTutor, OID_AM) VALUES
(35, NULL, 'Kpalimé', 'Koffi Kouassi', '+22890119988', 'koffi.kouassi@togo.tg', 103),
(36, NULL, 'Sokodé', 'Amina Tossou', '+22890228877', 'amina.tossou@togo.tg', 106),
(37, NULL, 'Kpalimé', 'Mensah Adjei', '+22890337766', 'mensah.adjei@togo.tg', 103);

-- 3. Nuevos contratos vigentes:
--    - OID 8 (Fundación Horizonte Sur S.L., entidad) tiene 2 apadrinados activos (35 y 36)
--    - OID 6 (Lucía Fernández Vega, persona física) suma un 2º apadrinado activo (37) además de Amara (9)
INSERT INTO ContratoPadrino (OID, aportacion, fecha_inicio, fecha_fin, OID_Be, OID_A) VALUES
(1610, 35.00, '2025-03-01', NULL, 8, 35),
(1611, 35.00, '2025-06-15', NULL, 8, 36),
(1612, 30.00, '2025-09-01', NULL, 6, 37);

-- 4. Pagos de noviembre 2026 asociados a estos nuevos contratos
INSERT INTO Pago (OID, cantidad, fecha, OID_Be) VALUES
(1713, 35.00, '2026-11-02', 8),
(1714, 35.00, '2026-11-02', 8),
(1715, 30.00, '2026-11-01', 6);

INSERT INTO TienePago (OID, OID_Pa, OID_A) VALUES
(1813, 1713, 35),
(1814, 1714, 36),
(1815, 1715, 37);