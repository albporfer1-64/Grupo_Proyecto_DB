USE practica;

-- Consulta 1: Listado de apadrinados activos, la localidad donde estudian y su nota media actual
SELECT 
    p.nombre, p.apellidos, a.localidad AS Zona_Estudio,
    a.nombreTutor,
    FUNC_Calcular_Media_Alumno(p.OID) AS Nota_Media
FROM Apadrinado a
JOIN Persona p ON a.OID = p.OID
WHERE a.fechaFinApadrinado IS NULL OR a.fechaFinApadrinado >= CURRENT_DATE
ORDER BY Nota_Media DESC;

-- Consulta 2: Proyectos ordenados por necesidad económica (Capital que falta por recaudar)
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

-- Consulta 3: Desglose del gasto total en sueldos agrupado por Misión (Oficios vs Apadrinamiento)
SELECT 
    CASE 
        WHEN sp.OID_EO IS NOT NULL THEN 'Escuela de Oficios'
        WHEN sp.OID_AM IS NOT NULL THEN 'Apadrinamiento'
    END AS Mision_Destino,
    COUNT(sp.OID) AS Numero_Nominas_Pagadas,
    SUM(sp.cantidad) AS Gasto_Total_Sueldos
FROM SueldoPagado sp
GROUP BY Mision_Destino;

-- Consulta 4: Llamadas a benefactores con valoración negativa o normal (Para revisión por directiva)
SELECT 
    am.fecha, am.hora, 
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