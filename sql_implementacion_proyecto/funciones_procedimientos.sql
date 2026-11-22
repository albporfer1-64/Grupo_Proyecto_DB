DELIMITER //

-- =========================================================================
-- PROCEDIMIENTOS DE ALTA SEGURA (Resolución "Huevo y la Gallina")
-- =========================================================================

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
        
        -- 2. Crear al Apadrinado (disparará TRG_RN01 y TRG_RN04 automáticamente)
        INSERT INTO Apadrinado (OID, fechaFinApadrinado, localidad, nombreTutor, telefonoTutor, emailTutor, OID_AM) 
        VALUES (p_OID, NULL, p_localidad, p_nombreTutor, p_telefonoTutor, p_emailTutor, p_OID_AM);
        
        -- 3. Crear su Contrato vinculándolo al Padrino/Benefactor (disparará TRG_RN02)
        INSERT INTO ContratoPadrino (OID, aportacion, fecha_inicio, fecha_fin, OID_Be, OID_A) 
        VALUES (p_OID_Contrato, p_aportacion, p_fecha_inicio, NULL, p_OID_Be, p_OID);
    COMMIT;
END //

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
        
        -- 2. Crear al Trabajador (disparará TRG_RN04 automáticamente)
        INSERT INTO Trabajador (OID, NIF, correo, telefono, rol) 
        VALUES (p_OID, p_NIF, p_correo, p_telefono, p_rol);
        
        -- 3. Crear su Contrato asignado a una misión y con sueldo (validará el arco exclusivo CHECK)
        INSERT INTO ContratoTrabajador (OID, sueldo, fecha_inicio, fecha_fin, OID_T, OID_EO, OID_AM) 
        VALUES (p_OID_Contrato, p_sueldo, p_fecha_inicio, NULL, p_OID, p_OID_EO, p_OID_AM);
    COMMIT;
END //

-- Procedimiento para cerrar el contrato actual de un apadrinado y asignarle uno nuevo
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

-- Procedimiento para renovar o recontratar a un trabajador existente
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

DELIMITER ;