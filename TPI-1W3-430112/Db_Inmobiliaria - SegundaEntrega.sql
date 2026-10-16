CREATE DATABASE InmobiliariaDB;
GO

USE InmobiliariaDB;
GO


-------------------------------------- PAIS --------------------------------------

CREATE TABLE Pais
(
    id_pais INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(100) NOT NULL UNIQUE,

    CONSTRAINT pk_id_pais
        PRIMARY KEY (id_pais)
);
GO


-------------------------------------- PROVINCIA --------------------------------------

CREATE TABLE Provincia
(
    id_provincia INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    id_pais INT NOT NULL,

    CONSTRAINT pk_id_provincia
        PRIMARY KEY (id_provincia),

    CONSTRAINT fk_provincia_id_pais
        FOREIGN KEY (id_pais)
        REFERENCES Pais(id_pais),

    UNIQUE (nombre, id_pais)
);
GO


-------------------------------------- CIUDAD --------------------------------------

CREATE TABLE Ciudad
(
    id_ciudad INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    id_provincia INT NOT NULL,

    CONSTRAINT pk_id_ciudad
        PRIMARY KEY (id_ciudad),

    CONSTRAINT fk_ciudad_id_provincia
        FOREIGN KEY (id_provincia)
        REFERENCES Provincia(id_provincia),

    UNIQUE (nombre, id_provincia)
);
GO


-------------------------------------- DIRECCION --------------------------------------

CREATE TABLE Direccion
(
    id_direccion INT IDENTITY(1,1) NOT NULL,
    calle VARCHAR(120) NOT NULL,
    numero INT NOT NULL,
    piso VARCHAR(10) NULL,
    departamento VARCHAR(10) NULL,
    codigo_postal VARCHAR(10) NULL,
    id_ciudad INT NOT NULL,

    CONSTRAINT pk_id_direccion
        PRIMARY KEY (id_direccion),

    CONSTRAINT fk_direccion_id_ciudad
        FOREIGN KEY (id_ciudad)
        REFERENCES Ciudad(id_ciudad)
);
GO


-------------------------------------- GRUPO --------------------------------------

CREATE TABLE Grupo
(
    id_grupo INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(255) NULL,

    CONSTRAINT pk_id_grupo
        PRIMARY KEY (id_grupo)
);
GO


-------------------------------------- INMOBILIARIA --------------------------------------

CREATE TABLE Inmobiliaria
(
    id_inmobiliaria INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    cuit VARCHAR(11) NOT NULL UNIQUE,
    telefono VARCHAR(30) NULL,
    email VARCHAR(150) NULL,
    id_direccion INT NOT NULL,
    id_grupo INT NULL,

    CONSTRAINT pk_id_inmobiliaria
        PRIMARY KEY (id_inmobiliaria),

    CONSTRAINT fk_inmobiliaria_id_direccion
        FOREIGN KEY (id_direccion)
        REFERENCES Direccion(id_direccion),

    CONSTRAINT fk_inmobiliaria_id_grupo
        FOREIGN KEY (id_grupo)
        REFERENCES Grupo(id_grupo)
);
GO


-------------------------------------- PERSONA --------------------------------------

CREATE TABLE Persona
(
    id_persona INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    dni VARCHAR(10) NOT NULL UNIQUE,
    cuil VARCHAR(11) NULL,
    telefono VARCHAR(30) NULL,
    email VARCHAR(150) NULL,
    fecha_nacimiento DATE NULL,
    id_direccion INT NULL,

    CONSTRAINT pk_id_persona
        PRIMARY KEY (id_persona),

    CONSTRAINT fk_persona_id_direccion
        FOREIGN KEY (id_direccion)
        REFERENCES Direccion(id_direccion)
);
GO


-------------------------------------- TIPO PERSONA --------------------------------------

CREATE TABLE TipoPersona
(
    id_tipo_persona INT IDENTITY(1,1) NOT NULL,
    descripcion VARCHAR(50) NOT NULL UNIQUE,

    CONSTRAINT pk_id_tipo_persona
        PRIMARY KEY (id_tipo_persona)
);
GO


-------------------------------------- TIPO PERSONA --------------------------------------

CREATE TABLE PersonaTipo
(
    id_persona INT NOT NULL,
    id_tipo_persona INT NOT NULL,

    CONSTRAINT pk_id_persona_id_tipo_persona
        PRIMARY KEY (id_persona, id_tipo_persona),

    CONSTRAINT fk_personatipo_id_persona
        FOREIGN KEY (id_persona)
        REFERENCES Persona(id_persona),

    CONSTRAINT fk_personatipo_id_tipo_persona
        FOREIGN KEY (id_tipo_persona)
        REFERENCES TipoPersona(id_tipo_persona)
);
GO


-------------------------------------- TIPO INMUEBLE --------------------------------------

CREATE TABLE TipoInmueble
(
    id_tipo_inmueble INT IDENTITY(1,1) NOT NULL,
    descripcion VARCHAR(50) NOT NULL UNIQUE,

    CONSTRAINT pk_id_tipo_inmueble
        PRIMARY KEY (id_tipo_inmueble)
);
GO


-------------------------------------- ESTADO INMUEBLE --------------------------------------

CREATE TABLE EstadoInmueble
(
    id_estado_inmueble INT IDENTITY(1,1) NOT NULL,
    descripcion VARCHAR(50) NOT NULL UNIQUE,

    CONSTRAINT pk_id_estado_inmueble
        PRIMARY KEY (id_estado_inmueble)
);
GO


-------------------------------------- INMUEBLE --------------------------------------

CREATE TABLE Inmueble
(
    id_inmueble INT IDENTITY(1,1) NOT NULL,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    titulo VARCHAR(150) NOT NULL,
    descripcion VARCHAR(500) NULL,
    superficie_total DECIMAL(10,2) NOT NULL,
    superficie_cubierta DECIMAL(10,2) NULL,
    ambientes INT NULL,
    dormitorios INT NULL,
    banios INT NULL,
    cochera BIT NOT NULL DEFAULT 0,
    id_direccion INT NOT NULL,
    id_tipo_inmueble INT NOT NULL,
    id_estado_inmueble INT NOT NULL,
    id_inmobiliaria INT NOT NULL,

    CONSTRAINT pk_id_inmueble
        PRIMARY KEY (id_inmueble),

    CONSTRAINT fk_inmueble_id_direccion
        FOREIGN KEY (id_direccion)
        REFERENCES Direccion(id_direccion),

    CONSTRAINT fk_inmueble_id_tipo_inmueble
        FOREIGN KEY (id_tipo_inmueble)
        REFERENCES TipoInmueble(id_tipo_inmueble),

    CONSTRAINT fk_inmueble_id_estado_inmueble
        FOREIGN KEY (id_estado_inmueble)
        REFERENCES EstadoInmueble(id_estado_inmueble),

    CONSTRAINT fk_inmueble_id_inmobiliaria
        FOREIGN KEY (id_inmobiliaria)
        REFERENCES Inmobiliaria(id_inmobiliaria)
);
GO


-------------------------------------- IMAGENES INMUEBLES --------------------------------------

CREATE TABLE ImagenesInmuebles
(
    id_imagen INT IDENTITY(1,1) NOT NULL,
    id_inmueble INT NOT NULL,
    url_imagen VARCHAR(500) NOT NULL,
    descripcion VARCHAR(150) NULL,
    principal BIT NOT NULL DEFAULT 0,
    fecha_carga DATE NOT NULL DEFAULT GETDATE(),

    CONSTRAINT pk_id_imagen
        PRIMARY KEY (id_imagen),

    CONSTRAINT fk_imagenesinmuebles_id_inmueble
        FOREIGN KEY (id_inmueble)
        REFERENCES Inmueble(id_inmueble)
);
GO


--------------------------------------PROPIETARIO  INMUEBLE --------------------------------------

CREATE TABLE PropietarioInmueble
(
    id_persona INT NOT NULL,
    id_inmueble INT NOT NULL,
    porcentaje_propiedad DECIMAL(5,2) NOT NULL,

    CONSTRAINT pk_id_persona_id_inmueble
        PRIMARY KEY (id_persona, id_inmueble),

    CONSTRAINT fk_propietarioinmueble_id_persona
        FOREIGN KEY (id_persona)
        REFERENCES Persona(id_persona),

    CONSTRAINT fk_propietarioinmueble_id_inmueble
        FOREIGN KEY (id_inmueble)
        REFERENCES Inmueble(id_inmueble)
);
GO


-------------------------------------- TIPO OPERACION --------------------------------------

CREATE TABLE TipoOperacion
(
    id_tipo_operacion INT IDENTITY(1,1) NOT NULL,
    descripcion VARCHAR(50) NOT NULL UNIQUE,

    CONSTRAINT pk_id_tipo_operacion
        PRIMARY KEY (id_tipo_operacion)
);
GO


-------------------------------------- PUBLICACION --------------------------------------

CREATE TABLE Publicacion
(
    id_publicacion INT IDENTITY(1,1) NOT NULL,
    id_inmueble INT NOT NULL,
    id_tipo_operacion INT NOT NULL,
    precio DECIMAL(14,2) NOT NULL,
    moneda VARCHAR(3) NOT NULL DEFAULT 'ARS',
    fecha_publicacion DATE NOT NULL DEFAULT GETDATE(),
    fecha_baja DATE NULL,
    activa BIT NOT NULL DEFAULT 1,

    CONSTRAINT pk_id_publicacion
        PRIMARY KEY (id_publicacion),

    CONSTRAINT fk_publicacion_id_inmueble
        FOREIGN KEY (id_inmueble)
        REFERENCES Inmueble(id_inmueble),

    CONSTRAINT fk_publicacion_id_tipo_operacion
        FOREIGN KEY (id_tipo_operacion)
        REFERENCES TipoOperacion(id_tipo_operacion)
);
GO


-------------------------------------- CONTRATO --------------------------------------

CREATE TABLE Contrato
(
    id_contrato INT IDENTITY(1,1) NOT NULL,
    id_publicacion INT NOT NULL,
    id_cliente INT NOT NULL,
    id_agente INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NULL,
    monto_acordado DECIMAL(14,2) NOT NULL,
    comision_porcentaje DECIMAL(5,2) NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'Vigente',

    CONSTRAINT pk_id_contrato
        PRIMARY KEY (id_contrato),

    CONSTRAINT fk_contrato_id_publicacion
        FOREIGN KEY (id_publicacion)
        REFERENCES Publicacion(id_publicacion),

    CONSTRAINT fk_contrato_id_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES Persona(id_persona),

    CONSTRAINT fk_contrato_id_agente
        FOREIGN KEY (id_agente)
        REFERENCES Persona(id_persona)
);
GO


-------------------------------------- FACTURA --------------------------------------

CREATE TABLE Factura
(
    id_factura INT IDENTITY(1,1) NOT NULL,
    numero_factura VARCHAR(30) NOT NULL UNIQUE,
    id_contrato INT NOT NULL,
    fecha_emision DATE NOT NULL DEFAULT GETDATE(),
    fecha_vencimiento DATE NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'Pendiente',

    CONSTRAINT pk_id_factura
        PRIMARY KEY (id_factura),

    CONSTRAINT fk_factura_id_contrato
        FOREIGN KEY (id_contrato)
        REFERENCES Contrato(id_contrato)
);
GO


-------------------------------------- DETALLE FACTURA --------------------------------------

CREATE TABLE DetalleFactura
(
    id_detalle_factura INT IDENTITY(1,1) NOT NULL,
    id_factura INT NOT NULL,
    concepto VARCHAR(200) NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(14,2) NOT NULL,
    subtotal DECIMAL(14,2) NOT NULL,

    CONSTRAINT pk_id_detalle_factura
        PRIMARY KEY (id_detalle_factura),

    CONSTRAINT fk_detallefactura_id_factura
        FOREIGN KEY (id_factura)
        REFERENCES Factura(id_factura)
);
GO



-------------------------------------- INSERTS ------------------------------------


-------------------------------------- PAIS --------------------------------------
INSERT INTO Pais (nombre)
VALUES ('Argentina');
GO

-------------------------------------- PROVINCIA --------------------------------------
INSERT INTO Provincia (nombre, id_pais)
VALUES
('Córdoba', 1),
('Buenos Aires', 1),
('Santa Fe', 1);
GO

-------------------------------------- CIUDAD --------------------------------------
INSERT INTO Ciudad (nombre, id_provincia)
VALUES
('Córdoba Capital', 1),
('Villa Carlos Paz', 1),
('Río Cuarto', 1),
('La Plata', 2),
('Rosario', 3);
GO

-------------------------------------- DIRECCION --------------------------------------
INSERT INTO Direccion (calle, numero, piso, departamento, codigo_postal, id_ciudad)
VALUES
('Av. Hipólito Yrigoyen', 450, '2', 'B', '5000', 1),
('Obispo Trejo', 930, NULL, NULL, '5000', 1),
('Av. San Martín', 650, NULL, NULL, '5152', 2),
('Av. Colón', 1550, NULL, NULL, '5000', 1),
('San Martín', 230, NULL, NULL, '5152', 2),
('General Paz', 105, '1', 'A', '5152', 2),
('Calle 50', 820, '4', 'A', '1900', 4),
('Ituzaingó', 540, '3', 'C', '5000', 1),
('Duarte Quirós', 1800, NULL, NULL, '5000', 1),
('Av. Sabattini', 2550, NULL, NULL, '5000', 1),
('Av. Pueyrredón', 900, '5', 'B', '5000', 1),
('San Lorenzo', 430, '6', 'A', '2000', 5),
('Laprida', 710, NULL, NULL, '5000', 1),
('9 de Julio', 1220, NULL, NULL, '5800', 3),
('Buenos Aires', 340, '2', 'D', '5000', 1),
('Belgrano', 1450, NULL, NULL, '5000', 1),
('Av. Estrada', 120, '7', 'A', '5000', 1),
('Gauss', 5800, NULL, NULL, '5000', 1),
('Av. San Martín', 1800, '3', 'B', '5152', 2),
('Av. Colón', 3200, NULL, NULL, '5000', 1),
('Bv. Illia', 520, '8', 'C', '5000', 1),
('Camino San Carlos', 3400, NULL, NULL, '5000', 1),
('Calle 12', 1330, '5', 'A', '1900', 4),
('Calle 44', 980, NULL, NULL, '1900', 4),
('Sobremonte', 410, NULL, NULL, '5800', 3),
('Av. Cárcano', 110, '4', 'B', '5152', 2),
('Recta Martinolli', 6100, NULL, NULL, '5000', 1),
('Entre Ríos', 880, '6', 'D', '5000', 1),
('Av. Libertad', 280, NULL, NULL, '5152', 2);
GO

-------------------------------------- GRUPOS --------------------------------------
INSERT INTO Grupo (nombre, descripcion)
VALUES
('Grupo Centro Inmobiliario', 'Red de inmobiliarias que comparten cartera comercial y oportunidades de negocio'),
('Grupo Sierras', 'Red de inmobiliarias con operaciones principalmente en Córdoba y zonas turísticas');
GO

-------------------------------------- INMOBILIARIA --------------------------------------
INSERT INTO Inmobiliaria (nombre, cuit, telefono, email, id_direccion, id_grupo)
VALUES
('Inmobiliaria Córdoba SRL', '30714569871', '3514223344', 'contacto@inmocordoba.com', 1, 1),
('Nueva Córdoba Propiedades', '30719876542', '3514455667', 'ventas@nuevacordobaprop.com', 2, 1),
('Sierras Inmuebles', '30722334451', '3541432211', 'info@sierrasinmuebles.com', 3, 2),
('Horizonte Propiedades', '30733445562', '3514788990', 'contacto@horizonteprop.com', 4, NULL),
('Punilla Gestión Inmobiliaria', '30744556673', '3541498877', 'contacto@punillagestion.com', 29, 2);
GO

-------------------------------------- TIPOS DE PERSONA --------------------------------------
INSERT INTO TipoPersona (descripcion)
VALUES
('Cliente'),
('Propietario'),
('Agente inmobiliario');
GO

-------------------------------------- PERSONAS --------------------------------------
INSERT INTO Persona (nombre, apellido, dni, cuil, telefono, email, fecha_nacimiento, id_direccion)
VALUES
('Carlos', 'Gómez', '30123456', '20301234567', '3515488992', 'carlos.gomez@email.com', '1982-05-14', 5),
('Ana', 'Pérez', '25654321', '27256543214', '3515599887', 'ana.perez@email.com', '1978-11-20', 6),
('Juan', 'López', '35789456', '20357894563', '3515677889', 'juan.lopez@email.com', '1990-03-05', 7),
('María', 'Giménez', '28999888', '27289998884', '3515988776', 'maria.gimenez@email.com', '1985-09-12', 8),
('Pedro', 'Sánchez', '40111222', '20401112229', '3515333221', 'pedro.sanchez@email.com', '1995-01-22', 9),
('Lucía', 'Torres', '33444555', '27334445558', '3515112233', 'lucia.torres@email.com', '1988-06-18', 10),
('Martín', 'Rodríguez', '36999888', '20369998884', '3515776655', 'martin.rodriguez@email.com', '1992-08-09', 11),
('Sofía', 'Acosta', '27888777', '27278887774', '3414556677', 'sofia.acosta@email.com', '1980-02-11', 12),
('Diego', 'Fernández', '42123456', '20421234569', '3515223344', 'diego.fernandez@email.com', '1998-04-25', 13),
('Valentina', 'Ruiz', '38222333', '27382223336', '3584556677', 'valentina.ruiz@email.com', '1993-12-03', 14),
('Nicolás', 'Romero', '39555666', '20395556661', '3515667788', 'nicolas.romero@email.com', '1994-07-17', 15),
('Camila', 'Herrera', '31555777', '27315557774', '3515443322', 'camila.herrera@email.com', '1984-10-29', 16);
GO

-------------------------------------- PERSONA - TIPO PERSONA --------------------------------------
INSERT INTO PersonaTipo (id_persona, id_tipo_persona)
VALUES
(1, 2),
(2, 1),
(2, 2),
(3, 3),
(4, 3),
(5, 1),
(6, 1),
(6, 2),
(7, 3),
(8, 2),
(9, 1),
(10, 3),
(11, 1),
(12, 2);
GO

-------------------------------------- TIPOS DE INMUEBLE --------------------------------------
INSERT INTO TipoInmueble (descripcion)
VALUES
('Casa'),
('Departamento'),
('Terreno'),
('Local comercial'),
('Oficina');
GO

-------------------------------------- ESTADOS DE INMUEBLE --------------------------------------
INSERT INTO EstadoInmueble (descripcion)
VALUES
('Disponible'),
('Reservado'),
('Alquilado'),
('Vendido'),
('No disponible');
GO

-------------------------------------- TIPOS DE OPERACION --------------------------------------
INSERT INTO TipoOperacion (descripcion)
VALUES
('Venta'),
('Alquiler');
GO

-------------------------------------- INMUEBLES --------------------------------------
INSERT INTO Inmueble
(codigo, titulo, descripcion, superficie_total, superficie_cubierta, ambientes, dormitorios, banios, cochera, id_direccion, id_tipo_inmueble, id_estado_inmueble, id_inmobiliaria)
VALUES
('DEP-001', 'Departamento luminoso en Nueva Córdoba', 'Balcón al frente y buena iluminación natural', 75.00, 70.00, 3, 2, 1, 1, 17, 2, 1, 2),
('CAS-002', 'Casa familiar en Villa Belgrano', 'Patio amplio, quincho y pileta', 220.00, 180.00, 5, 3, 2, 1, 18, 1, 1, 1),
('DEP-003', 'Departamento céntrico en Villa Carlos Paz', 'Departamento amoblado próximo al centro', 60.00, 55.00, 2, 1, 1, 0, 19, 2, 3, 3),
('LOC-004', 'Local comercial sobre Avenida Colón', 'Local con vidriera y depósito', 110.00, 100.00, 2, 0, 1, 0, 20, 4, 1, 1),
('OFI-005', 'Oficina equipada en Nueva Córdoba', 'Oficina con sala de reuniones y recepción', 45.00, 45.00, 2, 0, 1, 0, 21, 5, 2, 2),
('TER-006', 'Terreno en zona sur', 'Terreno apto para vivienda unifamiliar', 450.00, NULL, NULL, NULL, NULL, 0, 22, 3, 1, 5),
('DEP-007', 'Departamento moderno en La Plata', 'Unidad con balcón y cochera', 80.00, 74.00, 3, 2, 2, 1, 23, 2, 4, 4),
('CAS-008', 'Casa con jardín en La Plata', 'Casa de dos plantas con patio y cochera', 180.00, 150.00, 5, 3, 2, 1, 24, 1, 1, 4),
('LOC-009', 'Local céntrico en Río Cuarto', 'Local en corredor comercial', 140.00, 130.00, 2, 0, 2, 0, 25, 4, 1, 1),
('DEP-010', 'Departamento con vista en Villa Carlos Paz', 'Vista a las sierras y balcón terraza', 68.00, 62.00, 3, 2, 1, 1, 26, 2, 1, 5),
('CAS-011', 'Casa premium en Recta Martinolli', 'Casa con cuatro dormitorios, quincho y pileta', 300.00, 250.00, 7, 4, 3, 1, 27, 1, 4, 1),
('OFI-012', 'Oficina profesional en zona centro', 'Piso alto, recepción y dos privados', 95.00, 90.00, 4, 0, 2, 1, 28, 5, 1, 2);
GO

-------------------------------------- IMAGENES INMUEBLES --------------------------------------
INSERT INTO ImagenesInmuebles (id_inmueble, url_imagen, descripcion, principal, fecha_carga)
VALUES
(1, '/imagenes/inmuebles/DEP-001/frente.jpg', 'Frente del edificio', 1, '2026-06-15'),
(1, '/imagenes/inmuebles/DEP-001/living.jpg', 'Living comedor', 0, '2026-06-15'),
(1, '/imagenes/inmuebles/DEP-001/cocina.jpg', 'Cocina', 0, '2026-06-15'),
(1, '/imagenes/inmuebles/DEP-001/dormitorio.jpg', 'Dormitorio principal', 0, '2026-06-15'),
(2, '/imagenes/inmuebles/CAS-002/frente.jpg', 'Frente de la propiedad', 1, '2026-08-01'),
(2, '/imagenes/inmuebles/CAS-002/patio.jpg', 'Patio y pileta', 0, '2026-08-01'),
(3, '/imagenes/inmuebles/DEP-003/living.jpg', 'Living', 1, '2026-02-01'),
(3, '/imagenes/inmuebles/DEP-003/balcon.jpg', 'Balcón', 0, '2026-02-01'),
(4, '/imagenes/inmuebles/LOC-004/frente.jpg', 'Frente comercial', 1, '2026-09-01'),
(4, '/imagenes/inmuebles/LOC-004/salon.jpg', 'Salón principal', 0, '2026-09-01'),
(4, '/imagenes/inmuebles/LOC-004/deposito.jpg', 'Depósito', 0, '2026-09-01'),
(5, '/imagenes/inmuebles/OFI-005/recepcion.jpg', 'Recepción', 1, '2026-10-01'),
(7, '/imagenes/inmuebles/DEP-007/frente.jpg', 'Frente del edificio', 1, '2026-01-15'),
(7, '/imagenes/inmuebles/DEP-007/balcon.jpg', 'Balcón', 0, '2026-01-15'),
(8, '/imagenes/inmuebles/CAS-008/frente.jpg', 'Frente de la casa', 1, '2026-09-10'),
(8, '/imagenes/inmuebles/CAS-008/living.jpg', 'Living', 0, '2026-09-10'),
(8, '/imagenes/inmuebles/CAS-008/cocina.jpg', 'Cocina', 0, '2026-09-10'),
(8, '/imagenes/inmuebles/CAS-008/jardin.jpg', 'Jardín', 0, '2026-09-10'),
(9, '/imagenes/inmuebles/LOC-009/frente.jpg', 'Frente del local', 1, '2026-08-20'),
(9, '/imagenes/inmuebles/LOC-009/interior.jpg', 'Interior del local', 0, '2026-08-20'),
(10, '/imagenes/inmuebles/DEP-010/frente.jpg', 'Frente del edificio', 1, '2026-06-01'),
(10, '/imagenes/inmuebles/DEP-010/living.jpg', 'Living comedor', 0, '2026-06-01'),
(10, '/imagenes/inmuebles/DEP-010/vista.jpg', 'Vista desde el balcón', 0, '2026-06-01'),
(11, '/imagenes/inmuebles/CAS-011/frente.jpg', 'Frente de la casa', 1, '2026-03-01'),
(11, '/imagenes/inmuebles/CAS-011/pileta.jpg', 'Patio y pileta', 0, '2026-03-01'),
(12, '/imagenes/inmuebles/OFI-012/recepcion.jpg', 'Recepción y acceso', 1, '2026-09-15');
GO

-------------------------------------- PROPIETARIO INMUEBLE --------------------------------------
INSERT INTO PropietarioInmueble (id_persona, id_inmueble, porcentaje_propiedad)
VALUES
(1, 1, 100.00),
(1, 2, 50.00),
(6, 2, 50.00),
(2, 3, 100.00),
(2, 4, 100.00),
(6, 5, 100.00),
(6, 6, 100.00),
(8, 7, 100.00),
(8, 8, 100.00),
(12, 9, 100.00),
(12, 10, 100.00),
(1, 11, 50.00),
(12, 11, 50.00),
(2, 12, 100.00);
GO

-------------------------------------- PUBLICACIONES --------------------------------------
INSERT INTO Publicacion
(id_inmueble, id_tipo_operacion, precio, moneda, fecha_publicacion, fecha_baja, activa)
VALUES
(1, 2, 650000.00, 'ARS', '2026-06-15', NULL, 1),
(2, 1, 245000.00, 'USD', '2026-08-01', NULL, 1),
(3, 2, 420000.00, 'ARS', '2026-02-01', '2026-02-28', 0),
(4, 2, 900000.00, 'ARS', '2026-09-01', NULL, 1),
(5, 2, 580000.00, 'ARS', '2026-10-01', NULL, 1),
(6, 1, 85000.00, 'USD', '2026-07-10', NULL, 1),
(7, 1, 125000.00, 'USD', '2026-01-15', '2026-02-15', 0),
(8, 1, 190000.00, 'USD', '2026-09-10', NULL, 1),
(9, 2, 720000.00, 'ARS', '2026-08-20', NULL, 1),
(10, 2, 480000.00, 'ARS', '2026-06-01', NULL, 1),
(11, 1, 310000.00, 'USD', '2026-03-01', '2026-04-20', 0),
(12, 2, 760000.00, 'ARS', '2026-09-15', NULL, 1),
(1, 2, 550000.00, 'ARS', '2025-12-01', '2026-01-31', 0),
(4, 2, 780000.00, 'ARS', '2025-05-15', '2026-05-31', 0),
(10, 2, 420000.00, 'ARS', '2025-02-10', '2026-02-28', 0),
(2, 1, 230000.00, 'USD', '2026-02-01', '2026-04-30', 0),
(8, 2, 580000.00, 'ARS', '2024-04-15', '2025-04-30', 0);
GO

-------------------------------------- CONTRATOS --------------------------------------
INSERT INTO Contrato
(id_publicacion, id_cliente, id_agente, fecha_inicio, fecha_fin, monto_acordado, comision_porcentaje, estado)
VALUES
(3, 5, 7, '2026-03-01', '2028-02-28', 420000.00, 4.50, 'Vigente'),
(7, 9, 10, '2026-02-15', '2026-02-15', 122000.00, 3.50, 'Finalizado'),
(11, 11, 3, '2026-04-20', '2026-04-20', 300000.00, 4.00, 'Finalizado'),
(13, 2, 4, '2025-02-01', '2026-01-31', 540000.00, 4.00, 'Finalizado'),
(14, 6, 3, '2025-06-01', '2026-05-31', 760000.00, 4.50, 'Finalizado'),
(15, 9, 7, '2025-03-01', '2026-02-28', 410000.00, 4.00, 'Finalizado'),
(17, 5, 10, '2024-05-01', '2025-04-30', 560000.00, 4.00, 'Finalizado');
GO

-------------------------------------- FACTURAS --------------------------------------
INSERT INTO Factura
(numero_factura, id_contrato, fecha_emision, fecha_vencimiento, estado)
VALUES
('A-0001-00000001', 1, '2026-03-01', '2026-03-10', 'Pendiente'),
('A-0001-00000002', 2, '2026-02-15', '2026-02-22', 'Pagada'),
('A-0001-00000003', 3, '2026-04-20', '2026-04-30', 'Pagada'),
('A-0001-00000004', 4, '2025-02-01', '2025-02-10', 'Pagada'),
('A-0001-00000005', 5, '2025-06-01', '2025-06-10', 'Pagada'),
('A-0001-00000006', 6, '2025-03-01', '2025-03-10', 'Pagada'),
('A-0001-00000007', 7, '2024-05-01', '2024-05-10', 'Pagada');
GO

-------------------------------------- DETALLES FACTURAS --------------------------------------
INSERT INTO DetalleFactura (id_factura, concepto, cantidad, precio_unitario, subtotal)
VALUES
(1, 'Honorarios inmobiliarios', 1, 18900.00, 18900.00),
(1, 'Gastos administrativos', 1, 5000.00, 5000.00),
(2, 'Honorarios inmobiliarios', 1, 4270.00, 4270.00),
(2, 'Gastos administrativos', 1, 300.00, 300.00),
(3, 'Honorarios inmobiliarios', 1, 12000.00, 12000.00),
(3, 'Gastos administrativos', 1, 500.00, 500.00),
(4, 'Honorarios inmobiliarios', 1, 21600.00, 21600.00),
(5, 'Honorarios inmobiliarios', 1, 34200.00, 34200.00),
(6, 'Honorarios inmobiliarios', 1, 16400.00, 16400.00),
(7, 'Honorarios inmobiliarios', 1, 22400.00, 22400.00);
GO



--------------------------------------SEGUNDA PARTE - CONSULTAS--------------------------------------


/*
1- Mostrar las publicaciones activas que tengan un precio menor al promedio de las publicaciones del mismo tipo de inmueble, operación y moneda.
*/
SELECT
    i.codigo,
    i.titulo,
    ti.descripcion AS tipo_inmueble,
    tor.descripcion AS tipo_operacion,
    p.precio,
    p.moneda
FROM Inmueble i
JOIN TipoInmueble ti
    ON i.id_tipo_inmueble = ti.id_tipo_inmueble
JOIN Publicacion p
    ON i.id_inmueble = p.id_inmueble
JOIN TipoOperacion tor
    ON p.id_tipo_operacion = tor.id_tipo_operacion
WHERE p.activa = 1
  AND p.precio < (
        SELECT AVG(p2.precio)
        FROM Publicacion p2
        JOIN Inmueble i2
            ON p2.id_inmueble = i2.id_inmueble
        WHERE p2.activa = 1
          AND p2.id_tipo_operacion = p.id_tipo_operacion
          AND p2.moneda = p.moneda
          AND i2.id_tipo_inmueble = i.id_tipo_inmueble
  )
ORDER BY tor.descripcion, ti.descripcion, p.precio;
GO

/*
2- Mostrar los inmuebles que nunca generaron un contrato.
*/
SELECT
    i.codigo,
    i.titulo,
    ti.descripcion AS tipo_inmueble,
    ei.descripcion AS estado_inmueble,
    inm.nombre AS inmobiliaria
FROM Inmueble i
JOIN TipoInmueble ti
    ON i.id_tipo_inmueble = ti.id_tipo_inmueble
JOIN EstadoInmueble ei
    ON i.id_estado_inmueble = ei.id_estado_inmueble
JOIN Inmobiliaria inm
    ON i.id_inmobiliaria = inm.id_inmobiliaria
WHERE EXISTS
(
    SELECT 1
    FROM Publicacion p0
    WHERE p0.id_inmueble = i.id_inmueble
)
AND NOT EXISTS
(
    SELECT 1
    FROM Publicacion p
    JOIN Contrato c
        ON p.id_publicacion = c.id_publicacion
    WHERE p.id_inmueble = i.id_inmueble
)
ORDER BY inm.nombre, i.titulo;
GO

/*
3- Mostrar los agentes que gestionaron al menos dos contratos realizados,
   indicando cantidad de operaciones, el promedio de comisiòn y la fecha del ultimo reciente.
*/
SELECT
    p.id_persona,
    p.nombre + ' ' + p.apellido AS agente,
    COUNT(c.id_contrato) AS cantidad_contratos,
    AVG(c.comision_porcentaje) AS comision_promedio,
    MAX(c.fecha_inicio) AS ultimo_contrato
FROM Persona p
JOIN PersonaTipo pt
    ON p.id_persona = pt.id_persona
JOIN TipoPersona tp
    ON pt.id_tipo_persona = tp.id_tipo_persona
JOIN Contrato c
    ON p.id_persona = c.id_agente
WHERE tp.descripcion = 'Agente inmobiliario'
GROUP BY
    p.id_persona,
    p.nombre,
    p.apellido
HAVING COUNT(c.id_contrato) >= 2
ORDER BY cantidad_contratos DESC, agente;
GO

/*
4- Mostrar el total facturado por cada contrato, junto con el inmueble,
   el tipo de operación y la moneda correspondiente.
*/

SELECT
    c.id_contrato,
    i.codigo,
    i.titulo,
    tor.descripcion AS tipo_operacion,
    pub.moneda,
    f.numero_factura,
    f.fecha_emision,
    df_total.total_factura
FROM Contrato c
JOIN Publicacion pub
    ON c.id_publicacion = pub.id_publicacion
JOIN TipoOperacion tor
    ON pub.id_tipo_operacion = tor.id_tipo_operacion
JOIN Inmueble i
    ON pub.id_inmueble = i.id_inmueble
JOIN Factura f
    ON c.id_contrato = f.id_contrato
JOIN
(
    SELECT
        id_factura,
        SUM(subtotal) AS total_factura
    FROM DetalleFactura
    GROUP BY id_factura
) AS df_total
    ON f.id_factura = df_total.id_factura
ORDER BY f.fecha_emision DESC;
GO

/*
5- Mostrar un resumen por cada grupo inmobiliario:
   cantidad de inmobiliarias que lo integran, cuantos inmuebles administran,
   cuantas publicaciones tienes activas y por ultimo cuantos contratos tienen vigentes.
*/

SELECT
    g.id_grupo,
    g.nombre AS grupo,
    COUNT(DISTINCT inm.id_inmobiliaria) AS cantidad_inmobiliarias,
    COUNT(DISTINCT i.id_inmueble) AS cantidad_inmuebles,
    COUNT(DISTINCT CASE WHEN p.activa = 1 THEN p.id_publicacion END) AS publicaciones_activas,
    COUNT(DISTINCT CASE WHEN c.estado = 'Vigente' THEN c.id_contrato END) AS contratos_vigentes
FROM Grupo g
LEFT JOIN Inmobiliaria inm
    ON g.id_grupo = inm.id_grupo
LEFT JOIN Inmueble i
    ON inm.id_inmobiliaria = i.id_inmobiliaria
LEFT JOIN Publicacion p
    ON i.id_inmueble = p.id_inmueble
LEFT JOIN Contrato c
    ON p.id_publicacion = c.id_publicacion
GROUP BY
    g.id_grupo,
    g.nombre
ORDER BY g.nombre;
GO

/*
6- Mostrar los inmuebles disponibles que tengan una publicacion activay menos de tres imagenes cargadas, 
   indicando la cantidad de imagenes de cada uno
*/
SELECT
    i.codigo,
    i.titulo,
    inm.nombre AS inmobiliaria,
    COUNT(DISTINCT img.id_imagen) AS cantidad_imagenes,
    CASE
        WHEN COUNT(DISTINCT img.id_imagen) = 0 THEN 'Sin imágenes'
        WHEN COUNT(DISTINCT img.id_imagen) < 3 THEN 'Material incompleto'
        ELSE 'Material completo'
    END AS estado_imagenes
FROM Inmueble i
JOIN EstadoInmueble ei
    ON i.id_estado_inmueble = ei.id_estado_inmueble
JOIN Inmobiliaria inm
    ON i.id_inmobiliaria = inm.id_inmobiliaria
JOIN Publicacion p
    ON i.id_inmueble = p.id_inmueble
LEFT JOIN ImagenesInmuebles img
    ON i.id_inmueble = img.id_inmueble
WHERE ei.descripcion = 'Disponible'
  AND p.activa = 1
GROUP BY
    i.codigo,
    i.titulo,
    inm.nombre
HAVING COUNT(DISTINCT img.id_imagen) < 3
ORDER BY cantidad_imagenes, i.titulo;
GO

/*
7- Mostrar los inmuebles disponibles que tengan una publicaciòn activa pero que todavia no tengan imagenes cargadas.
*/
SELECT
    i.codigo,
    i.titulo,
    ti.descripcion AS tipo_inmueble,
    inm.nombre AS inmobiliaria,
    c.nombre AS ciudad
FROM Inmueble i
JOIN TipoInmueble ti
    ON i.id_tipo_inmueble = ti.id_tipo_inmueble
JOIN EstadoInmueble ei
    ON i.id_estado_inmueble = ei.id_estado_inmueble
JOIN Inmobiliaria inm
    ON i.id_inmobiliaria = inm.id_inmobiliaria
JOIN Direccion d
    ON i.id_direccion = d.id_direccion
JOIN Ciudad c
    ON d.id_ciudad = c.id_ciudad
JOIN Publicacion p
    ON i.id_inmueble = p.id_inmueble
LEFT JOIN ImagenesInmuebles img
    ON i.id_inmueble = img.id_inmueble
WHERE ei.descripcion = 'Disponible'
  AND p.activa = 1
  AND img.id_imagen IS NULL
ORDER BY c.nombre, i.titulo;
GO

/*
8- Mostrar los propietarios que tengan dos o mas inmuebles, indicando la cantidad de propiedades que poseen y 
   en cuantas tienen el 100% de la propiedad.
*/
SELECT
    p.id_persona,
    p.nombre,
    p.apellido,
    p.dni,
    COUNT(DISTINCT pi.id_inmueble) AS cantidad_inmuebles,
    COUNT(DISTINCT CASE
        WHEN pi.porcentaje_propiedad = 100.00 THEN pi.id_inmueble
    END) AS propiedades_completas
FROM Persona p
JOIN PropietarioInmueble pi
    ON p.id_persona = pi.id_persona
GROUP BY
    p.id_persona,
    p.nombre,
    p.apellido,
    p.dni
HAVING COUNT(DISTINCT pi.id_inmueble) >= 2
ORDER BY cantidad_inmuebles DESC, p.apellido;
GO


--------------------------------------VISTA - INMUEBLES PUBLICADOS--------------------------------------


CREATE VIEW vw_InmueblesPublicados
AS
SELECT
    i.id_inmueble,
    i.codigo,
    i.titulo,
    ti.descripcion AS tipo_inmueble,
    ei.descripcion AS estado_inmueble,
    inm.nombre AS inmobiliaria,
    g.nombre AS grupo,
    c.nombre AS ciudad,
    d.calle,
    d.numero,
    tor.descripcion AS tipo_operacion,
    p.precio,
    p.moneda,
    p.fecha_publicacion
FROM Inmueble i
JOIN TipoInmueble ti
    ON i.id_tipo_inmueble = ti.id_tipo_inmueble
JOIN EstadoInmueble ei
    ON i.id_estado_inmueble = ei.id_estado_inmueble
JOIN Inmobiliaria inm
    ON i.id_inmobiliaria = inm.id_inmobiliaria
LEFT JOIN Grupo g
    ON inm.id_grupo = g.id_grupo
JOIN Direccion d
    ON i.id_direccion = d.id_direccion
JOIN Ciudad c
    ON d.id_ciudad = c.id_ciudad
JOIN Publicacion p
    ON i.id_inmueble = p.id_inmueble
JOIN TipoOperacion tor
    ON p.id_tipo_operacion = tor.id_tipo_operacion
WHERE p.activa = 1;
GO

/*
9- Utilizar la vista y mostrar los inmuebles que tienen publicaciones activas utilizando la vista creada,
   incluyendo sus datos principales, ubicacion, tipo de operacion y precio.
*/
SELECT
    codigo,
    titulo,
    tipo_inmueble,
    estado_inmueble,
    inmobiliaria,
    grupo,
    ciudad,
    tipo_operacion,
    precio,
    moneda
FROM vw_InmueblesPublicados
ORDER BY ciudad, tipo_operacion, precio;
GO



--------------------------------------PROCEDIMIENTO - BUSCAR INMUEBLES--------------------------------------


CREATE PROCEDURE sp_BuscarInmuebles
    @tipo_operacion VARCHAR(50),
    @ciudad VARCHAR(100),
    @moneda VARCHAR(3),
    @precio_maximo DECIMAL(14,2)
AS
BEGIN

    SELECT
        codigo,
        titulo,
        tipo_inmueble,
        inmobiliaria,
        grupo,
        ciudad,
        tipo_operacion,
        precio,
        moneda
    FROM vw_InmueblesPublicados
    WHERE tipo_operacion = @tipo_operacion
      AND ciudad = @ciudad
      AND moneda = @moneda
      AND precio <= @precio_maximo
      AND estado_inmueble = 'Disponible'
    ORDER BY precio ASC;

END;
GO

/*
10- Buscar inmuebles disponibles para la venta en Cordoba Capital que tengan un precio maximo de 250.000 USD, 
    utilizando el procedimiento almacenado creado anteriorimente.
*/
EXEC sp_BuscarInmuebles
    @tipo_operacion = 'Venta',
    @ciudad = 'Córdoba Capital',
    @moneda = 'USD',
    @precio_maximo = 250000.00;
GO
