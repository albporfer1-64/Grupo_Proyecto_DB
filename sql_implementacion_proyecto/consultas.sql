USE practica;

-- =========================================================================
-- CONSULTAS DEL PROYECTO 
-- =========================================================================

-- C01: Listado completo de apadrinados activos junto con los datos de su benefactor/padrino actual
SELECT 
    pa.nombre AS Nombre_Apadrinado,
    pa.apellidos AS Apellidos_Apadrinado,
    a.localidad AS Localidad_Apadrinado,
    pb.nombre AS Nombre_Benefactor,
    pb.apellidos AS Apellidos_Benefactor,
    b.NIF AS NIF_Benefactor,
    b.correo AS Correo_Benefactor,
    b.telefono AS Telefono_Benefactor
FROM Apadrinado a
JOIN Persona pa ON a.OID = pa.OID
LEFT JOIN ContratoPadrino cp ON a.OID = cp.OID_A 
    AND (cp.fecha_fin IS NULL OR cp.fecha_fin >= CURRENT_DATE)
LEFT JOIN Benefactor b ON cp.OID_Be = b.OID
LEFT JOIN Persona pb ON b.OID = pb.OID
WHERE a.fechaFinApadrinado IS NULL OR a.fechaFinApadrinado >= CURRENT_DATE
ORDER BY pa.apellidos, pa.nombre;

-- C02: Contratos de apadrinamiento vigentes con los benefactores, detallando aportación, fechas y partes implicadas
SELECT 
    cp.OID AS ID_Contrato,
    cp.aportacion AS Aportacion_Mensual,
    cp.fecha_inicio AS Fecha_Inicio,
    cp.fecha_fin AS Fecha_Fin,
    CONCAT(pb.nombre, ' ', pb.apellidos) AS Benefactor,
    b.NIF AS NIF_Benefactor,
    CONCAT(pa.nombre, ' ', pa.apellidos) AS Apadrinado
FROM ContratoPadrino cp
JOIN Benefactor b ON cp.OID_Be = b.OID
JOIN Persona pb ON b.OID = pb.OID
JOIN Apadrinado a ON cp.OID_A = a.OID
JOIN Persona pa ON a.OID = pa.OID
WHERE cp.fecha_fin IS NULL OR cp.fecha_fin >= CURRENT_DATE
ORDER BY cp.fecha_inicio DESC;

-- C03: Para cada misión de apadrinamiento, lista detallada de los apadrinados adscritos a ella
SELECT 
    am.Titulo AS Mision_Apadrinamiento,
    am.Localidad AS Localidad_Mision,
    p.nombre AS Nombre_Apadrinado,
    p.apellidos AS Apellidos_Apadrinado,
    p.fechaNacimiento AS Fecha_Nacimiento,
    a.localidad AS Localidad_Residencia,
    a.fechaFinApadrinado AS Fecha_Fin_Apadrinamiento
FROM Apadrinamiento am
JOIN Apadrinado a ON am.OID = a.OID_AM
JOIN Persona p ON a.OID = p.OID
ORDER BY am.Titulo, p.apellidos, p.nombre;

-- C04: Para cada misión de Escuela de Oficios, listado de estudiantes matriculados y curso que estudian
SELECT 
    eo.Titulo AS Escuela_De_Oficios,
    eo.Localidad AS Localidad_Escuela,
    p.nombre AS Nombre_Estudiante,
    p.apellidos AS Apellidos_Estudiante,
    IFNULL(GROUP_CONCAT(DISTINCT c.Titulo SEPARATOR ', '), 'Sin curso asignado') AS Curso_Estudiado,
    e.correo AS Correo,
    e.telefono AS Telefono,
    e.fecha_inicio AS Fecha_Inicio,
    e.fecha_fin AS Fecha_Fin
FROM Escuela_Oficios eo
JOIN Estudiante_O e ON eo.OID = e.OID_EO
JOIN Persona p ON e.OID = p.OID
LEFT JOIN NotaOficios no ON e.OID = no.OID_EO
LEFT JOIN ContieneAAsignatura ca ON no.OID_AO = ca.OID_AO
LEFT JOIN Curso c ON ca.OID_C = c.OID AND c.escuelaOficio = eo.OID
GROUP BY eo.OID, eo.Titulo, eo.Localidad, e.OID, p.nombre, p.apellidos, e.correo, e.telefono, e.fecha_inicio, e.fecha_fin
ORDER BY eo.Titulo, p.apellidos, p.nombre;

-- C05: Alumnos (apadrinados y estudiantes de la Escuela de Oficios) junto con las calificaciones obtenidas en cada asignatura
SELECT 
    'Apadrinado' AS Tipo_Alumno,
    p.nombre AS Nombre,
    p.apellidos AS Apellidos,
    aa.titulo AS Asignatura,
    na.nota AS Calificacion
FROM NotaApadrinado na
JOIN Apadrinado a ON na.OID_A = a.OID
JOIN Persona p ON a.OID = p.OID
JOIN AsignaturaApadrinado aa ON na.OID_AP = aa.OID

UNION ALL

SELECT 
    'Escuela de Oficios' AS Tipo_Alumno,
    p.nombre AS Nombre,
    p.apellidos AS Apellidos,
    ao.titulo AS Asignatura,
    no.nota AS Calificacion
FROM NotaOficios no
JOIN Estudiante_O eo ON no.OID_EO = eo.OID
JOIN Persona p ON eo.OID = p.OID
JOIN AsignaturaOficios ao ON no.OID_AO = ao.OID
ORDER BY Tipo_Alumno, Apellidos, Nombre, Asignatura;





-- C14: Listado de apadrinados activos, la localidad donde estudian, su tutor y su nota media actual
SELECT 
    p.nombre AS Nombre_Apadrinado,
    p.apellidos AS Apellidos_Apadrinado,
    a.localidad AS Zona_Estudio,
    a.nombreTutor AS Tutor_Legal,
    FUNC_Calcular_Media_Alumno(p.OID) AS Nota_Media
FROM Apadrinado a
JOIN Persona p ON a.OID = p.OID
WHERE a.fechaFinApadrinado IS NULL OR a.fechaFinApadrinado >= CURRENT_DATE
ORDER BY Nota_Media DESC;

-- C15: Proyectos ordenados por necesidad económica (capital que falta por recaudar)
SELECT 
    p.titulo AS Proyecto,
    p.capitalEstimado AS Capital_Objetivo,
    IFNULL(SUM(ab.cantidad), 0) AS Total_Recaudado,
    (p.capitalEstimado - IFNULL(SUM(ab.cantidad), 0)) AS Capital_Restante,
    FUNC_Porcentaje_Financiacion_Proyecto(p.OID) AS Porcentaje_Completado
FROM Proyecto p
LEFT JOIN Aportacion_B ab ON p.OID = ab.OID_P
GROUP BY p.OID, p.titulo, p.capitalEstimado
HAVING Capital_Restante > 0
ORDER BY Capital_Restante DESC;

-- C16: Desglose del gasto total en sueldos agrupado por Misión (Escuela de Oficios vs Apadrinamiento)
SELECT 
    CASE 
        WHEN sp.OID_EO IS NOT NULL THEN 'Escuela de Oficios'
        WHEN sp.OID_AM IS NOT NULL THEN 'Apadrinamiento'
    END AS Mision_Destino,
    COUNT(sp.OID) AS Numero_Nominas_Pagadas,
    SUM(sp.cantidad) AS Gasto_Total_Sueldos
FROM SueldoPagado sp
GROUP BY Mision_Destino;

-- C17: Acciones de marketing a benefactores con valoración negativa o normal (para revisión por directiva)
SELECT 
    am.fecha AS Fecha,
    am.hora AS Hora,
    pb.nombre AS Benefactor,
    pe.nombre AS Empleado_Gestor,
    am.valoracion_E AS Valoracion,
    am.contenido AS Motivo_Llamada
FROM AccionesMarketing am
JOIN Benefactor b ON am.OID_Be = b.OID
JOIN Persona pb ON b.OID = pb.OID
JOIN Empleado e ON am.OID_E = e.OID
JOIN Persona pe ON e.OID = pe.OID
WHERE am.valoracion_E IN ('MUY_MAL', 'MAL', 'NORMAL')
ORDER BY am.fecha DESC;

