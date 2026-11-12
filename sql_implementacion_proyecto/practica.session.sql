DROP DATABASE IF EXISTS practica;
CREATE DATABASE practica;
USE practica;

DROP TABLE IF EXISTS AccionesMarketing;
DROP TABLE IF EXISTS TieneContratoP;
DROP TABLE IF EXISTS ContieneAContratoP;
DROP TABLE IF EXISTS ContratoPadrino;
DROP TABLE IF EXISTS TienePago;
DROP TABLE IF EXISTS ContieneAPago;
DROP TABLE IF EXISTS Pago;
DROP TABLE IF EXISTS Aportacion_B;
DROP TABLE IF EXISTS ContieneAActividadesProyecto;
DROP TABLE IF EXISTS ActividadProyecto;
DROP TABLE IF EXISTS ContieneAProyecto;
DROP TABLE IF EXISTS Proyecto;
DROP TABLE IF EXISTS TieneSueldo;
DROP TABLE IF EXISTS ContieneASueldo;
DROP TABLE IF EXISTS SueldoPagado;
DROP TABLE IF EXISTS TieneContratoT;
DROP TABLE IF EXISTS ContieneAContratoT;
DROP TABLE IF EXISTS ContratoTrabajador;
DROP TABLE IF EXISTS Empleado;
DROP TABLE IF EXISTS Benefactor;
DROP TABLE IF EXISTS NotaApadrinado;
DROP TABLE IF EXISTS TrabajaEnApadrinado;
DROP TABLE IF EXISTS AsignaturaApadrinado;
DROP TABLE IF EXISTS TrabajaEnOficios;
DROP TABLE IF EXISTS Trabajador;
DROP TABLE IF EXISTS NotaOficios;
DROP TABLE IF EXISTS Estudiante_O;
DROP TABLE IF EXISTS ContieneAAsignatura;
DROP TABLE IF EXISTS AsignaturaOficios;
DROP TABLE IF EXISTS Apadrinado;
DROP TABLE IF EXISTS Estudiante_B;
DROP TABLE IF EXISTS Curso;
DROP TABLE IF EXISTS Apadrinamiento;
DROP TABLE IF EXISTS Becados;
DROP TABLE IF EXISTS Escuela_Oficios;
DROP TABLE IF EXISTS Mision;
DROP TABLE IF EXISTS Persona;

CREATE TABLE Persona (
    OID INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(150) NOT NULL,
    fechaNacimiento DATE NOT NULL
);

CREATE TABLE Mision (
    OID INT PRIMARY KEY,
    Titulo VARCHAR(150) UNIQUE NOT NULL,
    Localidad VARCHAR(100) NOT NULL,
    Descripcion TEXT
);

CREATE TABLE Escuela_Oficios (
    OID INT PRIMARY KEY,
    FOREIGN KEY (OID) REFERENCES Mision(OID)
);

CREATE TABLE Becados (
    OID INT PRIMARY KEY,
    FOREIGN KEY (OID) REFERENCES Mision(OID)
);

CREATE TABLE Apadrinamiento (
    OID INT PRIMARY KEY,
    FOREIGN KEY (OID) REFERENCES Mision(OID)
);

CREATE TABLE Curso (
    OID INT PRIMARY KEY,
    Titulo VARCHAR(150) UNIQUE NOT NULL,
    escuelaOficio INT,
    FOREIGN KEY (escuelaOficio) REFERENCES Escuela_Oficios(OID)
);

CREATE TABLE Estudiante_B (
    OID INT PRIMARY KEY,
    Correo VARCHAR(150) UNIQUE,
    Telefono VARCHAR(20) UNIQUE,
    QueEstudia VARCHAR(150),
    Destino VARCHAR(150),
    fecha_inicio DATE,
    fecha_fin DATE,
    becado INT,
    FOREIGN KEY (OID) REFERENCES Persona(OID),
    FOREIGN KEY (becado) REFERENCES Becados(OID)
);

CREATE TABLE Apadrinado (
    OID INT PRIMARY KEY,
    fechaFinApadrinado DATE,
    localidad VARCHAR(100),
    nombreTutor VARCHAR(150),
    telefonoTutor VARCHAR(20),
    emailTutor VARCHAR(150),
    apadrinamiento INT,
    FOREIGN KEY (OID) REFERENCES Persona(OID),
    FOREIGN KEY (apadrinamiento) REFERENCES Apadrinamiento(OID)
);

CREATE TABLE AsignaturaOficios (
    OID INT PRIMARY KEY,
    titulo VARCHAR(150)
);

CREATE TABLE ContieneAAsignatura (
    OID_CA INT PRIMARY KEY,
    OID_C INT,
    OID_AO INT,
    UNIQUE (OID_C, OID_AO),
    FOREIGN KEY (OID_C) REFERENCES Curso(OID),
    FOREIGN KEY (OID_AO) REFERENCES AsignaturaOficios(OID)
);

CREATE TABLE Estudiante_O (
    OID INT PRIMARY KEY,
    correo VARCHAR(150) UNIQUE,
    telefono VARCHAR(20) UNIQUE,
    fecha_inicio DATE,
    fecha_fin DATE,
    FOREIGN KEY (OID) REFERENCES Persona(OID)
);

CREATE TABLE NotaOficios (
    OID INT PRIMARY KEY,
    nota DECIMAL(4, 2),
    OID_AO INT,
    OID_EO INT,
    FOREIGN KEY (OID_AO) REFERENCES AsignaturaOficios(OID),
    FOREIGN KEY (OID_EO) REFERENCES Estudiante_O(OID)
);

CREATE TABLE Trabajador (
    OID INT PRIMARY KEY,
    NIF VARCHAR(20) UNIQUE,
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
    titulo VARCHAR(150)
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
    nota DECIMAL(4, 2),
    OID_A INT,
    OID_AP INT,
    FOREIGN KEY (OID_A) REFERENCES Apadrinado(OID),
    FOREIGN KEY (OID_AP) REFERENCES AsignaturaApadrinado(OID)
);

CREATE TABLE Benefactor (
    OID INT PRIMARY KEY,
    NIF VARCHAR(20) UNIQUE,
    telefono VARCHAR(20) UNIQUE,
    horasPosiblesLlamadas VARCHAR(100),
    correo VARCHAR(150) UNIQUE,
    individuo BOOLEAN,
    cuenta_bancaria VARCHAR(34) UNIQUE,
    FOREIGN KEY (OID) REFERENCES Persona(OID)
);

CREATE TABLE Empleado (
    OID INT PRIMARY KEY,
    NIF VARCHAR(20) UNIQUE NOT NULL,
    correo VARCHAR(150) UNIQUE,
    telefono VARCHAR(20) UNIQUE,
    rol VARCHAR(100),
    FOREIGN KEY (OID) REFERENCES Persona(OID)
);

CREATE TABLE ContratoTrabajador (
    OID INT PRIMARY KEY,
    sueldo DECIMAL(10, 2),
    fecha_inicio DATE,
    fecha_fin DATE
);

CREATE TABLE ContieneAContratoT (
    OID INT PRIMARY KEY,
    OID_CT INT,
    OID_M INT,
    FOREIGN KEY (OID_CT) REFERENCES ContratoTrabajador(OID),
    FOREIGN KEY (OID_M) REFERENCES Mision(OID)
);

CREATE TABLE TieneContratoT (
    OID INT PRIMARY KEY,
    OID_CT INT,
    OID_T INT,
    FOREIGN KEY (OID_CT) REFERENCES ContratoTrabajador(OID),
    FOREIGN KEY (OID_T) REFERENCES Trabajador(OID)
);

CREATE TABLE SueldoPagado (
    OID INT PRIMARY KEY,
    cantidad DECIMAL(10, 2),
    fecha DATE
);

CREATE TABLE ContieneASueldo (
    OID INT PRIMARY KEY,
    OID_SP INT,
    OID_M INT,
    FOREIGN KEY (OID_SP) REFERENCES SueldoPagado(OID),
    FOREIGN KEY (OID_M) REFERENCES Mision(OID)
);

CREATE TABLE TieneSueldo (
    OID INT PRIMARY KEY,
    OID_SP INT,
    OID_T INT,
    FOREIGN KEY (OID_SP) REFERENCES SueldoPagado(OID),
    FOREIGN KEY (OID_T) REFERENCES Trabajador(OID)
);

CREATE TABLE Proyecto (
    OID INT PRIMARY KEY,
    titulo VARCHAR(150) UNIQUE,
    contenido TEXT,
    capitalEstimado DECIMAL(12, 2),
    fecha_inicio DATE,
    fecha_fin DATE
);

CREATE TABLE ContieneAProyecto (
    OID INT PRIMARY KEY,
    OID_P INT,
    OID_M INT,
    FOREIGN KEY (OID_P) REFERENCES Proyecto(OID),
    FOREIGN KEY (OID_M) REFERENCES Mision(OID)
);

CREATE TABLE ActividadProyecto (
    OID INT PRIMARY KEY,
    titulo VARCHAR(150) UNIQUE,
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
    fecha DATE
);

CREATE TABLE ContieneAPago (
    OID INT PRIMARY KEY,
    OID_Be INT,
    OID_P INT,
    FOREIGN KEY (OID_Be) REFERENCES Benefactor(OID),
    FOREIGN KEY (OID_P) REFERENCES Pago(OID)
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
    fecha_fin DATE NOT NULL
);

CREATE TABLE ContieneAContratoP (
    OID INT PRIMARY KEY,
    OID_Be INT,
    OID_CP INT,
    FOREIGN KEY (OID_Be) REFERENCES Benefactor(OID),
    FOREIGN KEY (OID_CP) REFERENCES ContratoPadrino(OID)
);

CREATE TABLE TieneContratoP (
    OID INT PRIMARY KEY,
    OID_A INT,
    OID_CP INT,
    FOREIGN KEY (OID_A) REFERENCES Apadrinado(OID),
    FOREIGN KEY (OID_CP) REFERENCES ContratoPadrino(OID)
);

CREATE TABLE AccionesMarketing (
    OID INT PRIMARY KEY,
    hora TIME NOT NULL,
    fecha DATE NOT NULL,
    contenido TEXT,
    metodoComunicacion VARCHAR(100) NOT NULL,
    valoracion_E INT NOT NULL,
    OID_E INT,
    OID_Be INT,
    FOREIGN KEY (OID_E) REFERENCES Empleado(OID),
    FOREIGN KEY (OID_Be) REFERENCES Benefactor(OID)
);