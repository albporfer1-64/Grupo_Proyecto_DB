USE practica;

-- ==========================================
-- NIVEL 0: PERSONAS
-- ==========================================
INSERT INTO Persona (OID, nombre, apellidos, fechaNacimiento) VALUES
-- Trabajadores de Togo (1 - 3)
(1, 'Kwame', 'Nkrumah Abalo', '1982-04-15'),
(2, 'Afi', 'Koffi Mensah', '1988-09-22'),
(3, 'Kodjo', 'Toure Bassabi', '1979-11-03'),
(15, 'Fatou', 'Diop', '1992-05-14'),
(16, 'Koffi', 'Salami', '1985-11-20'),
-- Empleados de España (4 - 5)
(4, 'Elena', 'Gómez Navarro', '1990-02-14'),
(5, 'Carlos', 'Martínez Ruiz', '1985-07-30'),
-- Benefactores / Padrinos (6 - 8) -> Nota: El OID 5 también será Benefactor (solapamiento permitido)
(6, 'Lucía', 'Fernández Vega', '1975-12-10'),
(7, 'Javier', 'Sánchez Ortiz', '1968-05-19'),
(8, 'Fundación', 'Horizonte Sur S.L.', '2001-01-01'),
-- Apadrinados activos (9 - 10)
(9, 'Amara', 'Diallo Kossi', '2014-06-12'),
(10, 'Yao', 'Agbeko Lawson', '2012-03-25'),
-- Ex-Apadrinado que cumple 18 y pasa a Becado (11) -> Prueba exitosa para RN01 y Trigger RN04
(11, 'Kofi', 'Mensah Gnassingbe', '2006-05-10'),
-- Becados activos (12)
(12, 'Akossiwa', 'Amouzou Tchalla', '2005-08-19'),
-- Estudiantes Escuela de Oficios activos (13 - 14)
(13, 'Edem', 'Sodji Kpegba', '2004-11-30'),
(14, 'Mawuli', 'Ahiagba Dossou', '2003-01-20');

-- ==========================================
-- NIVEL 1: MISIONES (Jerarquía disjunta)
-- ==========================================
INSERT INTO Escuela_Oficios (OID, Titulo, Localidad, Descripcion) VALUES
(101, 'Centro Politécnico Atachiarare', 'Lomé', 'Formación profesional en mecánica, informática, electricidad y albañilería para jóvenes mayores de edad.');

INSERT INTO Becados (OID, Titulo, Localidad, Descripcion) VALUES
(102, 'Programa Impulso Universitario Togo', 'Kara', 'Becas de estudio superior y manutención para antiguos apadrinados.');

INSERT INTO Apadrinamiento (OID, Titulo, Localidad, Descripcion) VALUES
(103, 'Apadrinamiento Escolar Infantil', 'Kpalimé', 'Cuota mensual para escolarización básica, material y alimentación de menores de 18 años.');

-- ==========================================
-- NIVEL 2: CURSOS, BECADOS Y APADRINADOS
-- ==========================================
INSERT INTO Curso (OID, Titulo, escuelaOficio) VALUES
(201, 'Técnico en Informática y Redes', 101),
(202, 'Mecánica Automotriz y Agrícola', 101);

-- Apadrinados (9 y 10 activos; 11 FINALIZADO en 2024 para poder pasar a Estudiante_B)
INSERT INTO Apadrinado (OID, fechaFinApadrinado, localidad, nombreTutor, telefonoTutor, emailTutor, OID_AM) VALUES
(9, NULL, 'Kpalimé', 'Mamadou Diallo', '+22890112233', 'mamadou.diallo@togo.tg', 103),
(10, '2030-03-25', 'Kpalimé', 'Grace Lawson', '+22890445566', 'grace.lawson@togo.tg', 103),
(11, '2024-05-10', 'Kpalimé', 'Samuel Gnassingbe', '+22890778899', 'samuel.g@togo.tg', 103);

-- Estudiantes Becados (El OID 11 entra aquí SIN saltar el trigger porque su fechaFinApadrinado ya pasó)
INSERT INTO Estudiante_B (OID, Correo, Telefono, QueEstudia, Destino, fecha_inicio, fecha_fin, becado) VALUES
(11, 'kofi.mensah@univ-kara.tg', '+22891001122', 'Enfermería', 'Universidad de Kara', '2024-09-01', NULL, 102),
(12, 'akossiwa.amouzou@univ-lome.tg', '+22891334455', 'Ingeniería Agronómica', 'Universidad de Lomé', '2023-09-15', '2027-06-30', 102);

-- ==========================================
-- NIVEL 3: ASIGNATURAS, ESTUDIANTES OFICIOS, TRABAJADORES Y NOTAS
-- ==========================================
INSERT INTO AsignaturaOficios (OID, titulo) VALUES
(301, 'Sistemas Operativos y Hardware'),
(302, 'Programación Básica'),
(303, 'Motores Diésel y Maquinaria');

INSERT INTO ContieneAAsignatura (OID_CA, OID_C, OID_AO) VALUES
(1, 201, 301),
(2, 201, 302),
(3, 202, 303);

INSERT INTO Estudiante_O (OID, correo, telefono, fecha_inicio, fecha_fin, OID_EO) VALUES
(13, 'edem.sodji@oficios.tg', '+22892112233', '2025-10-01', NULL, 101),
(14, 'mawuli.ahiagba@oficios.tg', '+22892445566', '2025-10-01', '2027-07-15', 101);

INSERT INTO NotaOficios (OID, nota, OID_AO, OID_EO) VALUES
(401, 8.75, 301, 13),
(402, 7.50, 302, 13),
(403, 9.20, 303, 14);

INSERT INTO Trabajador (OID, NIF, correo, telefono, rol) VALUES
(1, 'TG-8849201A', 'kwame.nkrumah@atachiarare.org', '+22893111222', 'Profesor'),
(2, 'TG-7738192B', 'afi.koffi@atachiarare.org', '+22893333444', 'Profesor'),
(3, 'TG-6627183C', 'kodjo.toure@atachiarare.org', '+22893555666', 'Profesor');
(15, 'TG-5544332D', 'fatou.diop@atachiarare.org', '+22899887766', 'Administrativa'),
(16, 'TG-1122334E', 'koffi.salami@atachiarare.org', '+22899775533', 'Personal de Limpieza');


INSERT INTO TrabajaEnOficios (OID, OID_AO, OID_T) VALUES
(501, 301, 1),
(502, 302, 1),
(503, 303, 3);

INSERT INTO AsignaturaApadrinado (OID, titulo) VALUES
(601, 'Matemáticas y Cálculo'),
(602, 'Lengua Francesa y Lectura');

INSERT INTO TrabajaEnApadrinado (OID, OID_AP, OID_T) VALUES
(701, 601, 2),
(702, 602, 2);

INSERT INTO NotaApadrinado (OID, nota, OID_A, OID_AP) VALUES
(801, 9.00, 9, 601),
(802, 8.25, 9, 602),
(803, 6.80, 10, 601);

-- ==========================================
-- NIVEL 4: BENEFACTORES Y EMPLEADOS
-- ==========================================
-- El OID 5 es Empleado y también Benefactor (solapamiento válido según RN04)
INSERT INTO Benefactor (OID, NIF, telefono, horasPosiblesLlamadas, correo, individuo, cuenta_bancaria) VALUES
(5, '28765432M', '+34600112233', '18:00 - 20:30', 'carlos.martinez@gmail.com', TRUE, 'ES9121000418450200051332'),
(6, '30987654L', '+34611223344', '10:00 - 13:00', 'lucia.fvega@hotmail.com', TRUE, 'ES7600491500051234567892'),
(7, '45123987K', '+34622334455', '16:00 - 19:00', 'javier.sanchez@empresa.es', TRUE, 'ES1001822370410201567890'),
(8, 'G41998877', '+34954112233', '09:00 - 14:00', 'contacto@horizontesur.org', FALSE, 'ES3300810658100001234567');

INSERT INTO Empleado (OID, NIF, correo, telefono, rol) VALUES
(4, '29456123P', 'elena.gomez@atachiarare.org', '+34633445566', 'Coordinadora de Apadrinamientos'),
(5, '28765432M', 'carlos.martinez@atachiarare.org', '+34600112233', 'Tesorero y Contabilidad');

-- ==========================================
-- NIVEL 5: CONTRATOS, SUELDOS, PROYECTOS, PAGOS Y MARKETING
-- ==========================================
-- Contratos de Trabajadores (Arco exclusivo: solo OID_EO o solo OID_AM)
INSERT INTO ContratoTrabajador (OID, sueldo, fecha_inicio, fecha_fin, OID_T, OID_EO, OID_AM) VALUES
(901, 450.00, '2023-01-01', NULL, 1, 101, NULL),
(902, 420.00, '2023-03-15', NULL, 2, NULL, 103),
(903, 460.00, '2024-02-01', '2026-12-31', 3, 101, NULL),
(904, 400.00, '2025-01-01', NULL, 15, 101, NULL), 
(905, 350.00, '2025-02-15', NULL, 16, NULL, 103); 

-- Sueldos Pagados (Arco exclusivo)
INSERT INTO SueldoPagado (OID, cantidad, fecha, OID_T, OID_EO, OID_AM) VALUES
(1001, 450.00, '2026-10-31', 1, 101, NULL),
(1002, 420.00, '2026-10-31', 2, NULL, 103),
(1003, 460.00, '2026-10-31', 3, 101, NULL),
(1004, 400.00, '2026-10-31', 15, 101, NULL),
(1005, 350.00, '2026-10-31', 16, NULL, 103);

-- Proyectos y Actividades
INSERT INTO Proyecto (OID, titulo, contenido, capitalEstimado, fecha_inicio, fecha_fin) VALUES
(1101, 'Aula Solar Informática Lomé', 'Instalación de placas solares y 20 equipos reacondicionados.', 15000.00, '2026-01-15', '2026-12-20'),
(1102, 'Comedor Escolar Kpalimé', 'Rehabilitación de cocina y suministro anual de alimentos.', 8500.00, '2026-03-01', NULL);

-- Conexión Proyecto - Misión (Arco exclusivo triple: solo uno activo)
INSERT INTO ContieneAProyecto (OID, OID_P, OID_EO, OID_B, OID_AM) VALUES
(1201, 1101, 101, NULL, NULL),
(1202, 1102, NULL, NULL, 103);

INSERT INTO ActividadProyecto (OID, titulo, descripcion, coste, fecha_inicio, fecha_fin) VALUES
(1301, 'Compra de paneles fotovoltaicos', 'Adquisición e importación de 12 paneles solares.', 6500.00, '2026-02-01', '2026-03-15'),
(1302, 'Montaje de red eléctrica e internet', 'Cableado estructurado del aula.', 3200.00, '2026-04-01', '2026-05-10'),
(1303, 'Equipamiento de cocina industrial', 'Fogones de gas y menaje para 150 niños.', 4100.00, '2026-03-10', '2026-04-20');

INSERT INTO ContieneAActividadesProyecto (OID, OID_P, OID_AP) VALUES
(1401, 1101, 1301),
(1402, 1101, 1302),
(1403, 1102, 1303);

-- Aportaciones de Benefactores a Proyectos
INSERT INTO Aportacion_B (OID, cantidad, fecha, OID_P, OID_B) VALUES
(1501, 5000.00, '2026-01-20', 1101, 8),
(1502, 1200.00, '2026-02-10', 1101, 7),
(1503, 2500.00, '2026-03-05', 1102, 8);

-- Contratos de Padrinos con Apadrinados (RN02: Un único contrato vigente por apadrinado)
INSERT INTO ContratoPadrino (OID, aportacion, fecha_inicio, fecha_fin, OID_Be, OID_A) VALUES
(1601, 30.00, '2022-01-01', NULL, 6, 9),
(1602, 35.00, '2021-09-01', NULL, 5, 10),
(1603, 30.00, '2018-05-10', '2024-05-10', 7, 11);

-- Pagos mensuales de Padrinos asignados a Apadrinados
INSERT INTO Pago (OID, cantidad, fecha, OID_Be) VALUES
(1701, 30.00, '2026-11-01', 6),
(1702, 35.00, '2026-11-02', 5);

INSERT INTO TienePago (OID, OID_Pa, OID_A) VALUES
(1801, 1701, 9),
(1802, 1702, 10);

-- Acciones de Marketing (Empleado -> Benefactor)
INSERT INTO AccionesMarketing (OID, hora, fecha, contenido, metodoComunicacion, valoracion_E, OID_E, OID_Be) VALUES
(1901, '18:30:00', '2026-10-15', 'Llamada de seguimiento trimestral y envío de notas de Amara.', 'Teléfono', 'MUY_BIEN', 4, 6),
(1902, '11:15:00', '2026-10-20', 'Presentación de memoria económica del Aula Solar.', 'Videollamada', 'BIEN', 4, 8),
(1903, '17:00:00', '2026-11-05', 'Consulta sobre renovación de donación anual.', 'Correo Electrónico', 'NORMAL', 5, 7);