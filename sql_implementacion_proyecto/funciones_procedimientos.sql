USE practica;

DELIMITER //

-- =========================================================================
-- PROCEDIMIENTOS DEL PROYECTO (P01 - P05)
-- =========================================================================

-- P01: Alta segura y atómica de un nuevo apadrinado junto con su persona y contrato inicial
DROP PROCEDURE IF EXISTS PROC_Alta_Apadrinado_Segura //
CREATE PROCEDURE PROC_Alta_Apadrinado_Segura(
    IN p_OID INT, 
    IN p_nombre VARCHAR(100), 
    IN p_apellidos VARCHAR(150), 
    IN p_fechaNacimiento DATE,
    IN p_localidad VARCHAR(100), 
    IN p_nombreTutor VARCHAR(150), 
    IN p_telefonoTutor VARCHAR(20), 
    IN p_emailTutor VARCHAR(150),
    IN p_OID_AM INT, 
    IN p_OID_Contrato INT, 
    IN p_aportacion DECIMAL(10,2), 
    IN p_fecha_inicio DATE, 
    IN p_OID_Be INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
        -- 1. Crear a la Persona
        INSERT INTO Persona (OID, nombre, apellidos, fechaNacimiento) 
        VALUES (p_OID, p_nombre, p_apellidos, p_fechaNacimiento);
        
        -- 2. Crear al Apadrinado (disparará TRG_RN01 y TRG_RN03 automáticamente)
        INSERT INTO Apadrinado (OID, fechaFinApadrinado, localidad, nombreTutor, telefonoTutor, emailTutor, OID_AM) 
        VALUES (p_OID, NULL, p_localidad, p_nombreTutor, p_telefonoTutor, p_emailTutor, p_OID_AM);
        
        -- 3. Crear su Contrato vinculándolo al Padrino/Benefactor (disparará TRG_RN02)
        INSERT INTO ContratoPadrino (OID, aportacion, fecha_inicio, fecha_fin, OID_Be, OID_A) 
        VALUES (p_OID_Contrato, p_aportacion, p_fecha_inicio, NULL, p_OID_Be, p_OID);
    COMMIT;
END //

-- P02: Alta segura y atómica de un nuevo trabajador junto con su persona y contrato inicial
DROP PROCEDURE IF EXISTS PROC_Alta_Trabajador_Segura //
CREATE PROCEDURE PROC_Alta_Trabajador_Segura(
    IN p_OID INT, 
    IN p_nombre VARCHAR(100), 
    IN p_apellidos VARCHAR(150), 
    IN p_fechaNacimiento DATE,
    IN p_NIF VARCHAR(20), 
    IN p_correo VARCHAR(150), 
    IN p_telefono VARCHAR(20), 
    IN p_rol VARCHAR(100),
    IN p_OID_Contrato INT, 
    IN p_sueldo DECIMAL(10,2), 
    IN p_fecha_inicio DATE,
    IN p_OID_EO INT, 
    IN p_OID_AM INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
        -- 1. Crear a la Persona
        INSERT INTO Persona (OID, nombre, apellidos, fechaNacimiento) 
        VALUES (p_OID, p_nombre, p_apellidos, p_fechaNacimiento);
        
        -- 2. Crear al Trabajador (disparará TRG_RN03 automáticamente)
        INSERT INTO Trabajador (OID, NIF, correo, telefono, rol) 
        VALUES (p_OID, p_NIF, p_correo, p_telefono, p_rol);
        
        -- 3. Crear su Contrato asignado a una misión y con sueldo (validará el arco exclusivo CHECK)
        INSERT INTO ContratoTrabajador (OID, sueldo, fecha_inicio, fecha_fin, OID_T, OID_EO, OID_AM) 
        VALUES (p_OID_Contrato, p_sueldo, p_fecha_inicio, NULL, p_OID, p_OID_EO, p_OID_AM);
    COMMIT;
END //

-- P03: Cerrar el contrato actual de un apadrinado y asignarle un nuevo benefactor/padrino
DROP PROCEDURE IF EXISTS PROC_Cambiar_Padrino //
CREATE PROCEDURE PROC_Cambiar_Padrino(
    IN p_OID_Apadrinado INT,
    IN p_Fecha_Fin_Anterior DATE,
    IN p_OID_Nuevo_Contrato INT,
    IN p_OID_Nuevo_Benefactor INT,
    IN p_Nueva_Aportacion DECIMAL(10,2),    
    IN p_Fecha_Inicio_Nuevo DATE
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
        -- 1. Cerramos el contrato vigente anterior (si lo hubiera)
        UPDATE ContratoPadrino 
        SET fecha_fin = p_Fecha_Fin_Anterior 
        WHERE OID_A = p_OID_Apadrinado AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE);
        
        -- 2. Abrimos el nuevo contrato (TRG_RN02 validará que no quede ninguno duplicado)
        INSERT INTO ContratoPadrino (OID, aportacion, fecha_inicio, fecha_fin, OID_Be, OID_A)
        VALUES (p_OID_Nuevo_Contrato, p_Nueva_Aportacion, p_Fecha_Inicio_Nuevo, NULL, p_OID_Nuevo_Benefactor, p_OID_Apadrinado);
    COMMIT;
END //

-- P04: Renovar o registrar un nuevo contrato laboral para un trabajador existente
DROP PROCEDURE IF EXISTS PROC_Nuevo_Contrato_Trabajador //
CREATE PROCEDURE PROC_Nuevo_Contrato_Trabajador(
    IN p_OID_Trabajador INT,
    IN p_OID_Nuevo_Contrato INT,
    IN p_Nuevo_Sueldo DECIMAL(10,2),
    IN p_Fecha_Inicio DATE,
    IN p_OID_EO INT,
    IN p_OID_AM INT
)
BEGIN
    INSERT INTO ContratoTrabajador (OID, sueldo, fecha_inicio, fecha_fin, OID_T, OID_EO, OID_AM)
    VALUES (p_OID_Nuevo_Contrato, p_Nuevo_Sueldo, p_Fecha_Inicio, NULL, p_OID_Trabajador, p_OID_EO, p_OID_AM);
END //

-- P05: Revisión periódica mediante cursor de los contratos vigentes para detectar impagos o saldos pendientes (RC07)
DROP PROCEDURE IF EXISTS PROC_Revisar_Impagos_Mes //
CREATE PROCEDURE PROC_Revisar_Impagos_Mes(
    IN p_mes INT,
    IN p_anio INT
)
BEGIN
    DECLARE v_fin_cursor BOOLEAN DEFAULT FALSE;
    DECLARE v_id_contrato INT;
    DECLARE v_id_benefactor INT;
    DECLARE v_id_apadrinado INT;
    DECLARE v_nombre_padrino VARCHAR(255);
    DECLARE v_telefono VARCHAR(20);
    DECLARE v_correo VARCHAR(150);
    DECLARE v_nombre_apadrinado VARCHAR(255);
    DECLARE v_cuota DECIMAL(10, 2);
    DECLARE v_pagado DECIMAL(10, 2);
    DECLARE v_pendiente DECIMAL(10, 2);
    DECLARE v_mensaje_alerta VARCHAR(255);

    DECLARE cur_contratos_vigentes CURSOR FOR
        SELECT 
            cp.OID,
            cp.OID_Be,
            cp.OID_A,
            CONCAT(pb.nombre, ' ', pb.apellidos),
            b.telefono,
            b.correo,
            CONCAT(pa.nombre, ' ', pa.apellidos),
            cp.aportacion
        FROM ContratoPadrino cp
        JOIN Benefactor b ON cp.OID_Be = b.OID
        JOIN Persona pb ON b.OID = pb.OID
        JOIN Apadrinado a ON cp.OID_A = a.OID
        JOIN Persona pa ON a.OID = pa.OID
        WHERE cp.fecha_fin IS NULL OR cp.fecha_fin >= CURRENT_DATE;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_fin_cursor = TRUE;

    DROP TEMPORARY TABLE IF EXISTS TMP_Alertas_Impago;
    CREATE TEMPORARY TABLE TMP_Alertas_Impago (
        ID_Contrato INT,
        Padrino VARCHAR(255),
        Telefono VARCHAR(20),
        Correo VARCHAR(150),
        Apadrinado VARCHAR(255),
        Cuota_Acordada DECIMAL(10, 2),
        Cantidad_Pagada DECIMAL(10, 2),
        Saldo_Pendiente DECIMAL(10, 2),
        Aviso VARCHAR(255)
    );

    OPEN cur_contratos_vigentes;

    bucle_contratos: LOOP
        FETCH cur_contratos_vigentes INTO 
            v_id_contrato, v_id_benefactor, v_id_apadrinado,
            v_nombre_padrino, v_telefono, v_correo,
            v_nombre_apadrinado, v_cuota;

        IF v_fin_cursor THEN
            LEAVE bucle_contratos;
        END IF;

        SELECT IFNULL(SUM(p.cantidad), 0) INTO v_pagado
        FROM Pago p
        JOIN TienePago tp ON p.OID = tp.OID_Pa
        WHERE p.OID_Be = v_id_benefactor
          AND tp.OID_A = v_id_apadrinado
          AND MONTH(p.fecha) = p_mes
          AND YEAR(p.fecha) = p_anio;

        IF v_pagado < v_cuota THEN
            SET v_pendiente = v_cuota - v_pagado;

            IF v_pagado = 0 THEN
                SET v_mensaje_alerta = CONCAT('ALERTA RC07: Impago total de la cuota (', p_mes, '/', p_anio, ').');
            ELSE
                SET v_mensaje_alerta = CONCAT('ALERTA RC07: Pago incompleto en ', p_mes, '/', p_anio, '. Faltan ', v_pendiente, ' EUR.');
            END IF;

            INSERT INTO TMP_Alertas_Impago VALUES (
                v_id_contrato,
                v_nombre_padrino,
                v_telefono,
                v_correo,
                v_nombre_apadrinado,
                v_cuota,
                v_pagado,
                v_pendiente,
                v_mensaje_alerta
            );
        END IF;
    END LOOP bucle_contratos;

    CLOSE cur_contratos_vigentes;

    SELECT * FROM TMP_Alertas_Impago;
    DROP TEMPORARY TABLE IF EXISTS TMP_Alertas_Impago;
END //


-- =========================================================================
-- FUNCIONES DEL PROYECTO (F01 - F06)
-- =========================================================================

-- F01: Calcular la nota media de los alumnos activos en una asignatura concreta ('OFICIOS' o 'APADRINAMIENTO')
DROP FUNCTION IF EXISTS FUNC_Media_Asignatura //
CREATE FUNCTION FUNC_Media_Asignatura(
    p_OID_Asignatura INT,
    p_Tipo_Mision VARCHAR(20)
) RETURNS DECIMAL(4, 2)
READS SQL DATA
BEGIN
    DECLARE v_media DECIMAL(4, 2);

    IF p_Tipo_Mision = 'OFICIOS' THEN
        SELECT AVG(no.nota) INTO v_media
        FROM NotaOficios no
        JOIN Estudiante_O eo ON no.OID_EO = eo.OID
        WHERE no.OID_AO = p_OID_Asignatura
          AND (eo.fecha_fin IS NULL OR eo.fecha_fin >= CURRENT_DATE);
    ELSEIF p_Tipo_Mision = 'APADRINAMIENTO' THEN
        SELECT AVG(na.nota) INTO v_media
        FROM NotaApadrinado na
        JOIN Apadrinado a ON na.OID_A = a.OID
        WHERE na.OID_AP = p_OID_Asignatura
          AND (a.fechaFinApadrinado IS NULL OR a.fechaFinApadrinado >= CURRENT_DATE);
    END IF;

    RETURN IFNULL(v_media, 0.00);
END //

-- F02: Calcular recaudación, gastos o balance de una misión concreta (mensual si p_Mes tiene valor, anual si p_Mes es NULL)
DROP FUNCTION IF EXISTS FUNC_Balance_Mision //
CREATE FUNCTION FUNC_Balance_Mision(
    p_OID_Mision INT,
    p_Concepto VARCHAR(20), -- 'RECAUDACION', 'GASTOS' o 'BALANCE'
    p_Anio INT,
    p_Mes INT               -- Pasar NULL para cálculo anual
) RETURNS DECIMAL(12, 2)
READS SQL DATA
BEGIN
    DECLARE v_pagos_padrinos DECIMAL(12, 2) DEFAULT 0.00;
    DECLARE v_aportaciones_proy DECIMAL(12, 2) DEFAULT 0.00;
    DECLARE v_sueldos DECIMAL(12, 2) DEFAULT 0.00;
    DECLARE v_coste_actividades DECIMAL(12, 2) DEFAULT 0.00;
    DECLARE v_recaudacion DECIMAL(12, 2) DEFAULT 0.00;
    DECLARE v_gastos DECIMAL(12, 2) DEFAULT 0.00;

    -- Ingresos por cuotas de apadrinamiento vinculadas a la misión
    SELECT IFNULL(SUM(p.cantidad), 0) INTO v_pagos_padrinos
    FROM Pago p
    WHERE p.OID IN (
        SELECT tp.OID_Pa
        FROM TienePago tp
        JOIN Apadrinado a ON tp.OID_A = a.OID
        WHERE a.OID_AM = p_OID_Mision
    )
    AND (p_Anio IS NULL OR YEAR(p.fecha) = p_Anio)
    AND (p_Mes IS NULL OR MONTH(p.fecha) = p_Mes);

    -- Ingresos por aportaciones a proyectos de la misión
    SELECT IFNULL(SUM(ab.cantidad), 0) INTO v_aportaciones_proy
    FROM Aportacion_B ab
    WHERE ab.OID_P IN (
        SELECT cap.OID_P
        FROM ContieneAProyecto cap
        WHERE cap.OID_EO = p_OID_Mision OR cap.OID_B = p_OID_Mision OR cap.OID_AM = p_OID_Mision
    )
    AND (p_Anio IS NULL OR YEAR(ab.fecha) = p_Anio)
    AND (p_Mes IS NULL OR MONTH(ab.fecha) = p_Mes);

    -- Gastos por sueldos abonados en la misión
    SELECT IFNULL(SUM(sp.cantidad), 0) INTO v_sueldos
    FROM SueldoPagado sp
    WHERE (sp.OID_EO = p_OID_Mision OR sp.OID_AM = p_OID_Mision)
      AND (p_Anio IS NULL OR YEAR(sp.fecha) = p_Anio)
      AND (p_Mes IS NULL OR MONTH(sp.fecha) = p_Mes);

    -- Gastos por actividades de los proyectos de la misión
    SELECT IFNULL(SUM(ap.coste), 0) INTO v_coste_actividades
    FROM ActividadProyecto ap
    WHERE ap.OID IN (
        SELECT caap.OID_AP
        FROM ContieneAActividadesProyecto caap
        JOIN ContieneAProyecto cap ON caap.OID_P = cap.OID_P
        WHERE cap.OID_EO = p_OID_Mision OR cap.OID_B = p_OID_Mision OR cap.OID_AM = p_OID_Mision
    )
    AND (p_Anio IS NULL OR YEAR(ap.fecha_inicio) = p_Anio)
    AND (p_Mes IS NULL OR MONTH(ap.fecha_inicio) = p_Mes);

    SET v_recaudacion = v_pagos_padrinos + v_aportaciones_proy;
    SET v_gastos = v_sueldos + v_coste_actividades;

    IF p_Concepto = 'RECAUDACION' THEN
        RETURN v_recaudacion;
    ELSEIF p_Concepto = 'GASTOS' THEN
        RETURN v_gastos;
    ELSE
        RETURN v_recaudacion - v_gastos;
    END IF;
END //

-- F03: Calcular recaudación global, gastos globales o balance del conjunto de todas las misiones (mensual o anual)
DROP FUNCTION IF EXISTS FUNC_Balance_Global_Misiones //
CREATE FUNCTION FUNC_Balance_Global_Misiones(
    p_Concepto VARCHAR(20), -- 'RECAUDACION', 'GASTOS' o 'BALANCE'
    p_Anio INT,
    p_Mes INT               -- Pasar NULL para cálculo anual
) RETURNS DECIMAL(12, 2)
READS SQL DATA
BEGIN
    DECLARE v_pagos_totales DECIMAL(12, 2) DEFAULT 0.00;
    DECLARE v_aportaciones_totales DECIMAL(12, 2) DEFAULT 0.00;
    DECLARE v_sueldos_totales DECIMAL(12, 2) DEFAULT 0.00;
    DECLARE v_actividades_totales DECIMAL(12, 2) DEFAULT 0.00;
    DECLARE v_recaudacion DECIMAL(12, 2) DEFAULT 0.00;
    DECLARE v_gastos DECIMAL(12, 2) DEFAULT 0.00;

    SELECT IFNULL(SUM(cantidad), 0) INTO v_pagos_totales
    FROM Pago
    WHERE (p_Anio IS NULL OR YEAR(fecha) = p_Anio)
      AND (p_Mes IS NULL OR MONTH(fecha) = p_Mes);

    SELECT IFNULL(SUM(cantidad), 0) INTO v_aportaciones_totales
    FROM Aportacion_B
    WHERE (p_Anio IS NULL OR YEAR(fecha) = p_Anio)
      AND (p_Mes IS NULL OR MONTH(fecha) = p_Mes);

    SELECT IFNULL(SUM(cantidad), 0) INTO v_sueldos_totales
    FROM SueldoPagado
    WHERE (p_Anio IS NULL OR YEAR(fecha) = p_Anio)
      AND (p_Mes IS NULL OR MONTH(fecha) = p_Mes);

    SELECT IFNULL(SUM(coste), 0) INTO v_actividades_totales
    FROM ActividadProyecto
    WHERE (p_Anio IS NULL OR YEAR(fecha_inicio) = p_Anio)
      AND (p_Mes IS NULL OR MONTH(fecha_inicio) = p_Mes);

    SET v_recaudacion = v_pagos_totales + v_aportaciones_totales;
    SET v_gastos = v_sueldos_totales + v_actividades_totales;

    IF p_Concepto = 'RECAUDACION' THEN
        RETURN v_recaudacion;
    ELSEIF p_Concepto = 'GASTOS' THEN
        RETURN v_gastos;
    ELSE
        RETURN v_recaudacion - v_gastos;
    END IF;
END //

-- F04: Calcular el número total de alumnos distintos que tiene asignados un trabajador con rol de profesor
DROP FUNCTION IF EXISTS FUNC_Alumnos_Por_Profesor //
CREATE FUNCTION FUNC_Alumnos_Por_Profesor(
    p_OID_Trabajador INT
) RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_total_alumnos INT DEFAULT 0;

    SELECT COUNT(DISTINCT alumno_id) INTO v_total_alumnos
    FROM (
        SELECT no.OID_EO AS alumno_id
        FROM TrabajaEnOficios teo
        JOIN NotaOficios no ON teo.OID_AO = no.OID_AO
        WHERE teo.OID_T = p_OID_Trabajador

        UNION

        SELECT na.OID_A AS alumno_id
        FROM TrabajaEnApadrinado tea
        JOIN NotaApadrinado na ON tea.OID_AP = na.OID_AP
        WHERE tea.OID_T = p_OID_Trabajador
    ) AS alumnos_profesor;

    RETURN v_total_alumnos;
END //

-- F05: Calcular la nota media actual de un alumno concreto (utilizada en C06)
DROP FUNCTION IF EXISTS FUNC_Calcular_Media_Alumno //
CREATE FUNCTION FUNC_Calcular_Media_Alumno(
    p_OID_Alumno INT
) RETURNS DECIMAL(4, 2)
READS SQL DATA
BEGIN
    DECLARE v_media DECIMAL(4, 2);

    SELECT AVG(nota) INTO v_media
    FROM (
        SELECT nota FROM NotaApadrinado WHERE OID_A = p_OID_Alumno
        UNION ALL
        SELECT nota FROM NotaOficios WHERE OID_EO = p_OID_Alumno
    ) AS notas_alumno;

    RETURN IFNULL(v_media, 0.00);
END //

-- F06: Calcular el porcentaje de financiación alcanzado respecto al capital estimado de un proyecto (utilizada en C07)
DROP FUNCTION IF EXISTS FUNC_Porcentaje_Financiacion_Proyecto //
CREATE FUNCTION FUNC_Porcentaje_Financiacion_Proyecto(
    p_OID_Proyecto INT
) RETURNS DECIMAL(5, 2)
READS SQL DATA
BEGIN
    DECLARE v_estimado DECIMAL(12, 2);
    DECLARE v_recaudado DECIMAL(12, 2);

    SELECT capitalEstimado INTO v_estimado
    FROM Proyecto
    WHERE OID = p_OID_Proyecto;

    IF v_estimado IS NULL OR v_estimado = 0 THEN
        RETURN 0.00;
    END IF;

    SELECT IFNULL(SUM(cantidad), 0) INTO v_recaudado
    FROM Aportacion_B
    WHERE OID_P = p_OID_Proyecto;

    RETURN ROUND((v_recaudado / v_estimado) * 100, 2);
END //

DELIMITER ;