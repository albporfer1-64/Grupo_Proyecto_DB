USE practica;

-- =========================================================================
-- DISPARADORES (TRIGGERS) PARA REGLAS DE NEGOCIO (Cruzando Tablas)
-- Se ejecutan después de la carga inicial de datos para no bloquear el histórico
-- =========================================================================
DELIMITER //

DROP TRIGGER IF EXISTS TRG_RN04_Apadrinado_INS //
CREATE TRIGGER TRG_RN04_Apadrinado_INS BEFORE INSERT ON Apadrinado
FOR EACH ROW
BEGIN
    DECLARE num_activos INT;
    SELECT COUNT(*) INTO num_activos FROM (
        SELECT OID FROM Estudiante_B WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
        UNION ALL
        SELECT OID FROM Estudiante_O WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
        UNION ALL
        SELECT OID FROM Apadrinado WHERE OID = NEW.OID AND (fechaFinApadrinado IS NULL OR fechaFinApadrinado >= CURRENT_DATE)
    ) AS activos;
    
    IF num_activos > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RN04: La persona ya está recibiendo ayuda económica activa y no puede abrir otra nueva misión.';
    END IF;
END; //

DROP TRIGGER IF EXISTS TRG_RN04_Estudiante_B_INS //
CREATE TRIGGER TRG_RN04_Estudiante_B_INS BEFORE INSERT ON Estudiante_B
FOR EACH ROW
BEGIN
    DECLARE num_activos INT;
    SELECT COUNT(*) INTO num_activos FROM (
        SELECT OID FROM Estudiante_B WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
        UNION ALL
        SELECT OID FROM Estudiante_O WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
        UNION ALL
        SELECT OID FROM Apadrinado WHERE OID = NEW.OID AND (fechaFinApadrinado IS NULL OR fechaFinApadrinado >= CURRENT_DATE)
    ) AS activos;
    
    IF num_activos > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RN04: La persona ya está recibiendo ayuda económica activa y no puede abrir otra nueva misión.';
    END IF;
END; //

DROP TRIGGER IF EXISTS TRG_RN04_Estudiante_O_INS //
CREATE TRIGGER TRG_RN04_Estudiante_O_INS BEFORE INSERT ON Estudiante_O
FOR EACH ROW
BEGIN
    DECLARE num_activos INT;
    SELECT COUNT(*) INTO num_activos FROM (
        SELECT OID FROM Estudiante_B WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
        UNION ALL
        SELECT OID FROM Estudiante_O WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
        UNION ALL
        SELECT OID FROM Apadrinado WHERE OID = NEW.OID AND (fechaFinApadrinado IS NULL OR fechaFinApadrinado >= CURRENT_DATE)
    ) AS activos;
    
    IF num_activos > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RN04: La persona ya está recibiendo ayuda económica activa y no puede abrir otra nueva misión.';
    END IF;
END; //

DROP TRIGGER IF EXISTS TRG_RN04_Apadrinado_UPD //
CREATE TRIGGER TRG_RN04_Apadrinado_UPD BEFORE UPDATE ON Apadrinado
FOR EACH ROW
BEGIN
    DECLARE num_activos INT;
    IF NEW.fechaFinApadrinado IS NULL OR NEW.fechaFinApadrinado >= CURRENT_DATE THEN
        SELECT COUNT(*) INTO num_activos FROM (
            SELECT OID FROM Estudiante_B WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
            UNION ALL
            SELECT OID FROM Estudiante_O WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
            UNION ALL
            SELECT OID FROM Apadrinado WHERE OID = NEW.OID AND OID <> OLD.OID AND (fechaFinApadrinado IS NULL OR fechaFinApadrinado >= CURRENT_DATE)
        ) AS activos;
        
        IF num_activos > 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RN04: No se puede reactivar el apadrinamiento; la persona ya tiene otra ayuda activa.';
        END IF;
    END IF;
END; //

DROP TRIGGER IF EXISTS TRG_RN04_Estudiante_B_UPD //
CREATE TRIGGER TRG_RN04_Estudiante_B_UPD BEFORE UPDATE ON Estudiante_B
FOR EACH ROW
BEGIN
    DECLARE num_activos INT;
    IF NEW.fecha_fin IS NULL OR NEW.fecha_fin >= CURRENT_DATE THEN
        SELECT COUNT(*) INTO num_activos FROM (
            SELECT OID FROM Estudiante_B WHERE OID = NEW.OID AND OID <> OLD.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
            UNION ALL
            SELECT OID FROM Estudiante_O WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
            UNION ALL
            SELECT OID FROM Apadrinado WHERE OID = NEW.OID AND (fechaFinApadrinado IS NULL OR fechaFinApadrinado >= CURRENT_DATE)
        ) AS activos;
        
        IF num_activos > 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RN04: No se puede reactivar la beca; la persona ya tiene otra ayuda activa.';
        END IF;
    END IF;
END; //

DROP TRIGGER IF EXISTS TRG_RN04_Estudiante_O_UPD //
CREATE TRIGGER TRG_RN04_Estudiante_O_UPD BEFORE UPDATE ON Estudiante_O
FOR EACH ROW
BEGIN
    DECLARE num_activos INT;
    IF NEW.fecha_fin IS NULL OR NEW.fecha_fin >= CURRENT_DATE THEN
        SELECT COUNT(*) INTO num_activos FROM (
            SELECT OID FROM Estudiante_B WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
            UNION ALL
            SELECT OID FROM Estudiante_O WHERE OID = NEW.OID AND OID <> OLD.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
            UNION ALL
            SELECT OID FROM Apadrinado WHERE OID = NEW.OID AND (fechaFinApadrinado IS NULL OR fechaFinApadrinado >= CURRENT_DATE)
        ) AS activos;
        
        IF num_activos > 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RN04: No se puede reactivar la escuela de oficios; la persona ya tiene otra ayuda activa.';
        END IF;
    END IF;
END; //

DROP TRIGGER IF EXISTS TRG_RN04_Trabajador_INS //
CREATE TRIGGER TRG_RN04_Trabajador_INS BEFORE INSERT ON Trabajador
FOR EACH ROW
BEGIN
    DECLARE ayuda_activa INT;
    SELECT COUNT(*) INTO ayuda_activa FROM (
        SELECT OID FROM Estudiante_B WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
        UNION ALL
        SELECT OID FROM Estudiante_O WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
        UNION ALL
        SELECT OID FROM Apadrinado WHERE OID = NEW.OID AND (fechaFinApadrinado IS NULL OR fechaFinApadrinado >= CURRENT_DATE)
    ) AS activos;

    IF ayuda_activa > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RN04: Una persona con ayuda económica activa no puede ser Trabajador.';
    END IF;
END; //

DROP TRIGGER IF EXISTS TRG_RN04_Empleado_INS //
CREATE TRIGGER TRG_RN04_Empleado_INS BEFORE INSERT ON Empleado
FOR EACH ROW
BEGIN
    DECLARE ayuda_activa INT;
    SELECT COUNT(*) INTO ayuda_activa FROM (
        SELECT OID FROM Estudiante_B WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
        UNION ALL
        SELECT OID FROM Estudiante_O WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
        UNION ALL
        SELECT OID FROM Apadrinado WHERE OID = NEW.OID AND (fechaFinApadrinado IS NULL OR fechaFinApadrinado >= CURRENT_DATE)
    ) AS activos;

    IF ayuda_activa > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RN04: Una persona con ayuda económica activa no puede ser Empleado.';
    END IF;
END; //

DROP TRIGGER IF EXISTS TRG_RN04_Benefactor_INS //
CREATE TRIGGER TRG_RN04_Benefactor_INS BEFORE INSERT ON Benefactor
FOR EACH ROW
BEGIN
    DECLARE ayuda_activa INT;
    SELECT COUNT(*) INTO ayuda_activa FROM (
        SELECT OID FROM Estudiante_B WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
        UNION ALL
        SELECT OID FROM Estudiante_O WHERE OID = NEW.OID AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE)
        UNION ALL
        SELECT OID FROM Apadrinado WHERE OID = NEW.OID AND (fechaFinApadrinado IS NULL OR fechaFinApadrinado >= CURRENT_DATE)
    ) AS activos;

    IF ayuda_activa > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RN04: Una persona con ayuda económica activa no puede ser Benefactor.';
    END IF;
END; //

DROP TRIGGER IF EXISTS TRG_RN02_ContratoPadrino_INS //
CREATE TRIGGER TRG_RN02_ContratoPadrino_INS BEFORE INSERT ON ContratoPadrino
FOR EACH ROW
BEGIN
    DECLARE contratos_vigentes INT;
    IF NEW.fecha_fin IS NULL OR NEW.fecha_fin >= CURRENT_DATE THEN
        SELECT COUNT(*) INTO contratos_vigentes 
        FROM ContratoPadrino 
        WHERE OID_A = NEW.OID_A 
          AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE);
          
        IF contratos_vigentes > 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RN02: Este apadrinado ya tiene un contrato vigente con un benefactor.';
        END IF;
    END IF;
END; //

DROP TRIGGER IF EXISTS TRG_RN02_ContratoPadrino_UPD //
CREATE TRIGGER TRG_RN02_ContratoPadrino_UPD BEFORE UPDATE ON ContratoPadrino
FOR EACH ROW
BEGIN
    DECLARE contratos_vigentes INT;
    IF NEW.fecha_fin IS NULL OR NEW.fecha_fin >= CURRENT_DATE THEN
        SELECT COUNT(*) INTO contratos_vigentes 
        FROM ContratoPadrino 
        WHERE OID_A = NEW.OID_A 
          AND OID <> OLD.OID
          AND (fecha_fin IS NULL OR fecha_fin >= CURRENT_DATE);
          
        IF contratos_vigentes > 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RN02: No se puede reactivar el contrato; el apadrinado ya tiene otro contrato vigente.';
        END IF;
    END IF;
END; //

DROP TRIGGER IF EXISTS TRG_RN01_Apadrinado_Edad //
CREATE TRIGGER TRG_RN01_Apadrinado_Edad BEFORE INSERT ON Apadrinado
FOR EACH ROW
BEGIN
    DECLARE fecha_nac DATE;
    DECLARE edad INT;
    
    IF NEW.fechaFinApadrinado IS NULL OR NEW.fechaFinApadrinado >= CURRENT_DATE THEN
        SELECT fechaNacimiento INTO fecha_nac FROM Persona WHERE OID = NEW.OID;
        SET edad = TIMESTAMPDIFF(YEAR, fecha_nac, CURRENT_DATE);
        
        IF edad >= 18 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RN01: La misión de apadrinamiento es solo para menores de 18 años.';
        END IF;
    END IF;
END; //

DELIMITER ;