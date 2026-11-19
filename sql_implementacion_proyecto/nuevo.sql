DROP DATABASE IF EXISTS practica;
CREATE DATABASE practica;
USE practica;

-- 1. LIMPIEZA DE TABLAS (Orden inverso a las dependencias)
DROP TABLE IF EXISTS AccionesMarketing;
DROP TABLE IF EXISTS TienePago;
DROP TABLE IF EXISTS ContratoPadrino;
DROP TABLE IF EXISTS Pago;
DROP TABLE IF EXISTS Aportacion_B;
DROP TABLE IF EXISTS ContieneAActividadesProyecto;
DROP TABLE IF EXISTS ActividadProyecto;
DROP TABLE IF EXISTS ContieneAProyecto;
DROP TABLE IF EXISTS Proyecto;
DROP TABLE IF EXISTS SueldoPagado;
DROP TABLE IF EXISTS ContratoTrabajador;
DROP TABLE IF EXISTS NotaApadrinado;
DROP TABLE IF EXISTS TrabajaEnApadrinado;
DROP TABLE IF EXISTS AsignaturaApadrinado;
DROP TABLE IF EXISTS TrabajaEnOficios;
DROP TABLE IF EXISTS NotaOficios;
DROP TABLE IF EXISTS Trabajador;
DROP TABLE IF EXISTS ContieneAAsignatura;
DROP TABLE IF EXISTS AsignaturaOficios;
DROP TABLE IF EXISTS Estudiante_O;
DROP TABLE IF EXISTS Apadrinado;
DROP TABLE IF EXISTS Estudiante_B;
DROP TABLE IF EXISTS Curso;
DROP TABLE IF EXISTS Benefactor;
DROP TABLE IF EXISTS Empleado;
DROP TABLE IF EXISTS Apadrinamiento;
DROP TABLE IF EXISTS Becados;
DROP TABLE IF EXISTS Escuela_Oficios;
DROP TABLE IF EXISTS Persona;

-- ==========================================
-- NIVEL 0
-- ==========================================
CREATE TABLE Persona (
    OID INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(150) NOT NULL,
    fechaNacimiento DATE NOT NULL
);

-- ==========================================
-- NIVEL 1: Jerarquía disjunta (Mision desaparece)
-- ==========================================
CREATE TABLE Escuela_Oficios (
    OID INT PRIMARY KEY,
    Titulo VARCHAR(150) UNIQUE NOT NULL,
    Localidad VARCHAR(100) NOT NULL,
    Descripcion TEXT
);

CREATE TABLE Becados (
    OID INT PRIMARY KEY,
    Titulo VARCHAR(150) UNIQUE NOT NULL,
    Localidad VARCHAR(100) NOT NULL,
    Descripcion TEXT
);

CREATE TABLE Apadrinamiento (
    OID INT PRIMARY KEY,
    Titulo VARCHAR(150) UNIQUE NOT NULL,
    Localidad VARCHAR(100) NOT NULL,
    Descripcion TEXT
);

-- ==========================================
-- NIVEL 2
-- ==========================================
CREATE TABLE Curso (
    OID INT PRIMARY KEY,
    Titulo VARCHAR(150) NOT NULL,
    escuelaOficio INT,
    FOREIGN KEY (escuelaOficio) REFERENCES Escuela_Oficios(OID)
);

CREATE TABLE Estudiante_B (
    OID INT PRIMARY KEY,
    Correo VARCHAR(150) UNIQUE NOT NULL, 
    Telefono VARCHAR(20) UNIQUE NOT NULL,
    QueEstudia VARCHAR(150) NOT NULL,
    Destino VARCHAR(150) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    becado INT,
    FOREIGN KEY (OID) REFERENCES Persona(OID),
    FOREIGN KEY (becado) REFERENCES Becados(OID)
);

CREATE TABLE Apadrinado (
    OID INT PRIMARY KEY,
    fechaFinApadrinado DATE,
    localidad VARCHAR(100) NOT NULL,
    nombreTutor VARCHAR(150) NOT NULL,
    telefonoTutor VARCHAR(20) NOT NULL,
    emailTutor VARCHAR(150) NOT NULL,
    OID_AM INT,
    FOREIGN KEY (OID) REFERENCES Persona(OID),
    FOREIGN KEY (OID_AM) REFERENCES Apadrinamiento(OID)
);

-- ==========================================
-- NIVEL 3
-- ==========================================
CREATE TABLE AsignaturaOficios (
    OID INT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL
);

CREATE TABLE ContieneAAsignatura (
    OID_CA INT PRIMARY KEY,
    OID_C INT NOT NULL,
    OID_AO INT NOT NULL,
    UNIQUE (OID_C, OID_AO),
    FOREIGN KEY (OID_C) REFERENCES Curso(OID),
    FOREIGN KEY (OID_AO) REFERENCES AsignaturaOficios(OID)
);

CREATE TABLE Estudiante_O (
    OID INT PRIMARY KEY,
    correo VARCHAR(150) UNIQUE NOT NULL,
    telefono VARCHAR(20) UNIQUE NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    OID_EO INT,
    FOREIGN KEY (OID) REFERENCES Persona(OID),
    FOREIGN KEY (OID_EO) REFERENCES Escuela_Oficios(OID)
);

CREATE TABLE NotaOficios (
    OID INT PRIMARY KEY,
    nota DECIMAL(4, 2) CHECK (nota >= 0 AND nota <= 10),
    OID_AO INT,
    OID_EO INT,
    FOREIGN KEY (OID_AO) REFERENCES AsignaturaOficios(OID),
    FOREIGN KEY (OID_EO) REFERENCES Estudiante_O(OID)
);

CREATE TABLE Trabajador (
    OID INT PRIMARY KEY,
    NIF VARCHAR(20) UNIQUE NOT NULL,
    correo VARCHAR(150) UNIQUE NOT NULL,
    telefono VARCHAR(20) UNIQUE NOT NULL,
    FOREIGN KEY (OID) REFERENCES Persona(OID)
);

CREATE TABLE TrabajaEnOficios (
    OID INT PRIMARY KEY,
    OID_AO INT,
    OID_T INT,
    FOREIGN KEY (OID_AO) REFERENCES AsignaturaOficios(OID),
    FOREIGN KEY (OID_T) REFERENCES Trabajador(OID)
);

CREATE TABLE AsignaturaApadrinado (
    OID INT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL
);

CREATE TABLE TrabajaEnApadrinado (
    OID INT PRIMARY KEY,
    OID_AP INT,
    OID_T INT,
    FOREIGN KEY (OID_AP) REFERENCES AsignaturaApadrinado(OID),
    FOREIGN KEY (OID_T) REFERENCES Trabajador(OID)
);

CREATE TABLE NotaApadrinado (
    OID INT PRIMARY KEY,
    nota DECIMAL(4, 2) CHECK (nota >= 0 AND nota <= 10),
    OID_A INT,
    OID_AP INT,
    FOREIGN KEY (OID_A) REFERENCES Apadrinado(OID),
    FOREIGN KEY (OID_AP) REFERENCES AsignaturaApadrinado(OID)
);

-- ==========================================
-- NIVEL 4
-- ==========================================
CREATE TABLE Benefactor (
    OID INT PRIMARY KEY,
    NIF VARCHAR(20) UNIQUE NOT NULL,
    telefono VARCHAR(20) UNIQUE NOT NULL,
    horasPosiblesLlamadas VARCHAR(100),
    correo VARCHAR(150) UNIQUE NOT NULL,
    individuo BOOLEAN,
    cuenta_bancaria VARCHAR(34) UNIQUE NOT NULL,
    FOREIGN KEY (OID) REFERENCES Persona(OID)
);

CREATE TABLE Empleado (
    OID INT PRIMARY KEY,
    NIF VARCHAR(20) UNIQUE NOT NULL,
    correo VARCHAR(150) UNIQUE NOT NULL,
    telefono VARCHAR(20) UNIQUE NOT NULL,
    rol VARCHAR(100),
    FOREIGN KEY (OID) REFERENCES Persona(OID)
);

-- ==========================================
-- NIVEL 5
-- ==========================================
CREATE TABLE ContratoTrabajador (
    OID INT PRIMARY KEY,
    sueldo DECIMAL(10, 2),
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    OID_T INT,
    OID_EO INT,
    OID_AM INT,
    FOREIGN KEY (OID_T) REFERENCES Trabajador(OID),
    FOREIGN KEY (OID_EO) REFERENCES Escuela_Oficios(OID),
    FOREIGN KEY (OID_AM) REFERENCES Apadrinamiento(OID)
);

CREATE TABLE SueldoPagado (
    OID INT PRIMARY KEY,
    cantidad DECIMAL(10, 2),
    fecha DATE,
    OID_T INT,
    OID_EO INT,
    OID_AM INT,
    FOREIGN KEY (OID_T) REFERENCES Trabajador(OID),
    FOREIGN KEY (OID_EO) REFERENCES Escuela_Oficios(OID),
    FOREIGN KEY (OID_AM) REFERENCES Apadrinamiento(OID)
);

CREATE TABLE Proyecto (
    OID INT PRIMARY KEY,
    titulo VARCHAR(150) UNIQUE NOT NULL,
    contenido TEXT,
    capitalEstimado DECIMAL(12, 2),
    fecha_inicio DATE,
    fecha_fin DATE
);

CREATE TABLE ContieneAProyecto (
    OID INT PRIMARY KEY,
    OID_P INT,
    OID_EO INT,
    OID_B INT,
    OID_AM INT,
    FOREIGN KEY (OID_P) REFERENCES Proyecto(OID),
    FOREIGN KEY (OID_EO) REFERENCES Escuela_Oficios(OID),
    FOREIGN KEY (OID_B) REFERENCES Becados(OID),
    FOREIGN KEY (OID_AM) REFERENCES Apadrinamiento(OID)
);

CREATE TABLE ActividadProyecto (
    OID INT PRIMARY KEY,
    titulo VARCHAR(150) UNIQUE NOT NULL,
    descripcion TEXT,
    coste DECIMAL(10, 2),
    fecha_inicio DATE,
    fecha_fin DATE
);

CREATE TABLE ContieneAActividadesProyecto (
    OID INT PRIMARY KEY,
    OID_P INT,
    OID_AP INT,
    FOREIGN KEY (OID_P) REFERENCES Proyecto(OID),
    FOREIGN KEY (OID_AP) REFERENCES ActividadProyecto(OID)
);

CREATE TABLE Aportacion_B (
    OID INT PRIMARY KEY,
    cantidad DECIMAL(10, 2),
    fecha DATE,
    OID_P INT,
    OID_B INT,
    FOREIGN KEY (OID_P) REFERENCES Proyecto(OID),
    FOREIGN KEY (OID_B) REFERENCES Benefactor(OID)
);

CREATE TABLE Pago (
    OID INT PRIMARY KEY,
    cantidad DECIMAL(10, 2),
    fecha DATE,
    OID_Be INT,
    FOREIGN KEY (OID_Be) REFERENCES Benefactor(OID)
);

CREATE TABLE TienePago (
    OID INT PRIMARY KEY,
    OID_Pa INT,
    OID_A INT,
    FOREIGN KEY (OID_Pa) REFERENCES Pago(OID),
    FOREIGN KEY (OID_A) REFERENCES Apadrinado(OID)
);

CREATE TABLE ContratoPadrino (
    OID INT PRIMARY KEY,
    aportacion DECIMAL(10, 2),
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    OID_Be INT,
    OID_A INT,
    FOREIGN KEY (OID_Be) REFERENCES Benefactor(OID),
    FOREIGN KEY (OID_A) REFERENCES Apadrinado(OID)
);

CREATE TABLE AccionesMarketing (
    OID INT PRIMARY KEY,
    hora TIME NOT NULL,
    fecha DATE NOT NULL,
    contenido TEXT,
    metodoComunicacion VARCHAR(100) NOT NULL,
    valoracion_E ENUM('MUY_MAL', 'MAL', 'NORMAL', 'BIEN', 'MUY_BIEN') NOT NULL,
    OID_E INT,
    OID_Be INT,
    FOREIGN KEY (OID_E) REFERENCES Empleado(OID),
    FOREIGN KEY (OID_Be) REFERENCES Benefactor(OID)
);


-- ==========================================
-- DISPARADORES (TRIGGERS) PARA ASEGURAR LA RN04
-- ==========================================
DELIMITER //

CREATE TRIGGER TRG_RN04_Apadrinado BEFORE INSERT ON Apadrinado
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

CREATE TRIGGER TRG_RN04_Estudiante_B BEFORE INSERT ON Estudiante_B
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

CREATE TRIGGER TRG_RN04_Estudiante_O BEFORE INSERT ON Estudiante_O
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

DELIMITER ;