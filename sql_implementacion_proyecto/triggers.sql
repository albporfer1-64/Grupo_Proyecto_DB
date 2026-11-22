USE practica;

-- =========================================================================
-- 6.5 SCRIPT DE CREACIÓN DE TRIGGERS ASOCIADOS A REGLAS DE NEGOCIO
-- Nota: Ejecutar después del poblado inicial (6.2) para no bloquear históricos
-- =========================================================================
DELIMITER //

-- -------------------------------------------------------------------------
-- RN01: Límite de edad en Apadrinamiento (Solo menores de 18 años)
-- -------------------------------------------------------------------------

DROP TRIGGER IF EXISTS TRG_RN01_Apadrinado_Edad //
CREATE TRIGGER TRG_RN01_Apadrinado_Edad
BEFORE INSERT ON Apadrinado
FOR EACH ROW
BEGIN
    DECLARE v_fecha_nac DATE;
    DECLARE v_edad INT;
    
    IF NEW.fechaFinApadrinado IS NULL OR NEW.fechaFinApadrinado >= CURRENT_DATE THEN
        SELECT fechaNacimiento INTO v_fecha_nac 
        FROM Persona 
        WHERE OID = NEW.OID;
        
        SET v_edad = TIMESTAMPDIFF(YEAR, v_fecha_nac, CURRENT_DATE);
        
        IF v_edad >= 18 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'RN01: La misión de apadrinamiento es solo para menores de 18 años.';
        END IF;
    END IF;
END //


-- -------------------------------------------------------------------------
-- RN02: Un apadrinado solo puede tener un contrato de padrino vigente
-- -------------------------------------------------------------------------

DROP TRIGGER IF EXISTS TRG_RN02_ContratoPadrino_INS //
CREATE TRIGGER TRG_RN02_ContratoPadrino_INS
BEFORE INSERT ON ContratoPadrino
FOR EACH ROW
BEGIN
    DECLARE v_contratos_vigentes INT;
    
    IF NEW.fecha_fin IS NULL OR NEW.fecha_fin >= CURRENT_DATE THEN
        SELECT COUNT(*) INTO v_contratos_vigentes 
        FROM ContratoPadrino 
        WHERE OID_A = NEW.OID_A 
          AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE);
          
        IF v_contratos_vigentes > 0 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'RN02: Este apadrinado ya tiene un contrato vigente con un benefactor.';
        END IF;
    END IF;
END //

DROP TRIGGER IF EXISTS TRG_RN02_ContratoPadrino_UPD //
CREATE TRIGGER TRG_RN02_ContratoPadrino_UPD
BEFORE UPDATE ON ContratoPadrino
FOR EACH ROW
BEGIN
    DECLARE v_contratos_vigentes INT;
    
    IF NEW.fecha_fin IS NULL OR NEW.fecha_fin >= CURRENT_DATE THEN
        SELECT COUNT(*) INTO v_contratos_vigentes 
        FROM ContratoPadrino 
        WHERE OID_A = NEW.OID_A 
          AND OID <> OLD.OID
          AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE);
          
        IF v_contratos_vigentes > 0 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'RN02: No se puede reactivar el contrato; el apadrinado ya tiene otro contrato vigente.';
        END IF;
    END IF;
END //


-- -------------------------------------------------------------------------
-- RN04 (Parte A): Exclusividad entre misiones de ayuda (Altas - INSERT)
-- -------------------------------------------------------------------------

DROP TRIGGER IF EXISTS TRG_RN04_Apadrinado_INS //
CREATE TRIGGER TRG_RN04_Apadrinado_INS
BEFORE INSERT ON Apadrinado
FOR EACH ROW
BEGIN
    DECLARE v_num_activos INT;
    
    SELECT COUNT(*) INTO v_num_activos FROM (
        SELECT OID FROM Estudiante_B WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
        UNION ALL
        SELECT OID FROM Estudiante_O WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
        UNION ALL
        SELECT OID FROM Apadrinado   WHERE OID = NEW.OID AND (fechaFinApadrinado IS NULL OR fechaFinApadrinado >= CURRENT_DATE)
    ) AS activos;
    
    IF v_num_activos > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'RN04: La persona ya está recibiendo ayuda económica activa y no puede abrir otra nueva misión.';
    END IF;
END //

DROP TRIGGER IF EXISTS TRG_RN04_Estudiante_B_INS //
CREATE TRIGGER TRG_RN04_Estudiante_B_INS
BEFORE INSERT ON Estudiante_B
FOR EACH ROW
BEGIN
    DECLARE v_num_activos INT;
    
    SELECT COUNT(*) INTO v_num_activos FROM (
        SELECT OID FROM Estudiante_B WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
        UNION ALL
        SELECT OID FROM Estudiante_O WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
        UNION ALL
        SELECT OID FROM Apadrinado   WHERE OID = NEW.OID AND (fechaFinApadrinado IS NULL OR fechaFinApadrinado >= CURRENT_DATE)
    ) AS activos;
    
    IF v_num_activos > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'RN04: La persona ya está recibiendo ayuda económica activa y no puede abrir otra nueva misión.';
    END IF;
END //

DROP TRIGGER IF EXISTS TRG_RN04_Estudiante_O_INS //
CREATE TRIGGER TRG_RN04_Estudiante_O_INS
BEFORE INSERT ON Estudiante_O
FOR EACH ROW
BEGIN
    DECLARE v_num_activos INT;
    
    SELECT COUNT(*) INTO v_num_activos FROM (
        SELECT OID FROM Estudiante_B WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
        UNION ALL
        SELECT OID FROM Estudiante_O WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
        UNION ALL
        SELECT OID FROM Apadrinado   WHERE OID = NEW.OID AND (fechaFinApadrinado IS NULL OR fechaFinApadrinado >= CURRENT_DATE)
    ) AS activos;
    
    IF v_num_activos > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'RN04: La persona ya está recibiendo ayuda económica activa y no puede abrir otra nueva misión.';
    END IF;
END //


-- -------------------------------------------------------------------------
-- RN04 (Parte B): Exclusividad entre misiones de ayuda (Reactivaciones - UPDATE)
-- -------------------------------------------------------------------------

DROP TRIGGER IF EXISTS TRG_RN04_Apadrinado_UPD //
CREATE TRIGGER TRG_RN04_Apadrinado_UPD
BEFORE UPDATE ON Apadrinado
FOR EACH ROW
BEGIN
    DECLARE v_num_activos INT;
    
    IF NEW.fechaFinApadrinado IS NULL OR NEW.fechaFinApadrinado >= CURRENT_DATE THEN
        SELECT COUNT(*) INTO v_num_activos FROM (
            SELECT OID FROM Estudiante_B WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
            UNION ALL
            SELECT OID FROM Estudiante_O WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
            UNION ALL
            SELECT OID FROM Apadrinado   WHERE OID = NEW.OID AND OID <> OLD.OID AND (fechaFinApadrinado IS NULL OR fechaFinApadrinado >= CURRENT_DATE)
        ) AS activos;
        
        IF v_num_activos > 0 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'RN04: No se puede reactivar el apadrinamiento; la persona ya tiene otra ayuda activa.';
        END IF;
    END IF;
END //

DROP TRIGGER IF EXISTS TRG_RN04_Estudiante_B_UPD //
CREATE TRIGGER TRG_RN04_Estudiante_B_UPD
BEFORE UPDATE ON Estudiante_B
FOR EACH ROW
BEGIN
    DECLARE v_num_activos INT;
    
    IF NEW.fecha_fin IS NULL OR NEW.fecha_fin >= CURRENT_DATE THEN
        SELECT COUNT(*) INTO v_num_activos FROM (
            SELECT OID FROM Estudiante_B WHERE OID = NEW.OID AND OID <> OLD.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
            UNION ALL
            SELECT OID FROM Estudiante_O WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
            UNION ALL
            SELECT OID FROM Apadrinado   WHERE OID = NEW.OID AND (fechaFinApadrinado IS NULL OR fechaFinApadrinado >= CURRENT_DATE)
        ) AS activos;
        
        IF v_num_activos > 0 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'RN04: No se puede reactivar la beca; la persona ya tiene otra ayuda activa.';
        END IF;
    END IF;
END //

DROP TRIGGER IF EXISTS TRG_RN04_Estudiante_O_UPD //
CREATE TRIGGER TRG_RN04_Estudiante_O_UPD
BEFORE UPDATE ON Estudiante_O
FOR EACH ROW
BEGIN
    DECLARE v_num_activos INT;
    
    IF NEW.fecha_fin IS NULL OR NEW.fecha_fin >= CURRENT_DATE THEN
        SELECT COUNT(*) INTO v_num_activos FROM (
            SELECT OID FROM Estudiante_B WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
            UNION ALL
            SELECT OID FROM Estudiante_O WHERE OID = NEW.OID AND OID <> OLD.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
            UNION ALL
            SELECT OID FROM Apadrinado   WHERE OID = NEW.OID AND (fechaFinApadrinado IS NULL OR fechaFinApadrinado >= CURRENT_DATE)
        ) AS activos;
        
        IF v_num_activos > 0 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'RN04: No se puede reactivar la escuela de oficios; la persona ya tiene otra ayuda activa.';
        END IF;
    END IF;
END //


-- -------------------------------------------------------------------------
-- RN04 (Parte C): Incompatibilidad de ayuda activa con otros roles
-- -------------------------------------------------------------------------

DROP TRIGGER IF EXISTS TRG_RN04_Trabajador_INS //
CREATE TRIGGER TRG_RN04_Trabajador_INS
BEFORE INSERT ON Trabajador
FOR EACH ROW
BEGIN
    DECLARE v_ayuda_activa INT;
    
    SELECT COUNT(*) INTO v_ayuda_activa FROM (
        SELECT OID FROM Estudiante_B WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
        UNION ALL
        SELECT OID FROM Estudiante_O WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
        UNION ALL
        SELECT OID FROM Apadrinado   WHERE OID = NEW.OID AND (fechaFinApadrinado IS NULL OR fechaFinApadrinado >= CURRENT_DATE)
    ) AS activos;

    IF v_ayuda_activa > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'RN04: Una persona con ayuda económica activa no puede ser Trabajador.';
    END IF;
END //

DROP TRIGGER IF EXISTS TRG_RN04_Empleado_INS //
CREATE TRIGGER TRG_RN04_Empleado_INS
BEFORE INSERT ON Empleado
FOR EACH ROW
BEGIN
    DECLARE v_ayuda_activa INT;
    
    SELECT COUNT(*) INTO v_ayuda_activa FROM (
        SELECT OID FROM Estudiante_B WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
        UNION ALL
        SELECT OID FROM Estudiante_O WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
        UNION ALL
        SELECT OID FROM Apadrinado   WHERE OID = NEW.OID AND (fechaFinApadrinado IS NULL OR fechaFinApadrinado >= CURRENT_DATE)
    ) AS activos;

    IF v_ayuda_activa > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'RN04: Una persona con ayuda económica activa no puede ser Empleado.';
    END IF;
END //

DROP TRIGGER IF EXISTS TRG_RN04_Benefactor_INS //
CREATE TRIGGER TRG_RN04_Benefactor_INS
BEFORE INSERT ON Benefactor
FOR EACH ROW
BEGIN
    DECLARE v_ayuda_activa INT;
    
    SELECT COUNT(*) INTO v_ayuda_activa FROM (
        SELECT OID FROM Estudiante_B WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
        UNION ALL
        SELECT OID FROM Estudiante_O WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
        UNION ALL
        SELECT OID FROM Apadrinado   WHERE OID = NEW.OID AND (fechaFinApadrinado IS NULL OR fechaFinApadrinado >= CURRENT_DATE)
    ) AS activos;

    IF v_ayuda_activa > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'RN04: Una persona con ayuda económica activa no puede ser Benefactor.';
    END IF;
END //

DELIMITER ;