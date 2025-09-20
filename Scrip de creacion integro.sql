-- Creación de la base de datos
CREATE DATABASE cuchuflito_sa;

-- Selección de la base de datos para trabajar
USE cuchuflito_sa;

-- Tablas

-- Tablas de cuotas y roles

-- Medios de pago

CREATE TABLE medios_de_pago (
    ID_Medio INT NOT NULL,
    Medio_de_Pago VARCHAR(45) NOT NULL,
    Tipo_Pago VARCHAR(10),
    Permite_Cuotas TINYINT(1) DEFAULT 0,
    PRIMARY KEY (ID_Medio)
);

-- cuotas_pago

CREATE TABLE cuotas_pago (
    ID_Cuota INT NOT NULL AUTO_INCREMENT,
    ID_Medio INT NOT NULL,
    Cantidad_Cuotas INT,
    PRIMARY KEY (ID_Cuota),
    FOREIGN KEY (ID_Medio) REFERENCES medios_de_pago(ID_Medio),
    CHECK (Cantidad_Cuotas IN (1,3,6))
);

-- roles

CREATE TABLE roles (
    ID_Rol INT NOT NULL AUTO_INCREMENT,
    Rol VARCHAR(50) NOT NULL,
    Descripcion TEXT,
    PRIMARY KEY (ID_Rol)
);

-- empleados

CREATE TABLE empleados (
    Legajo INT UNSIGNED NOT NULL AUTO_INCREMENT,
    Nombre_completo VARCHAR(100) NOT NULL,
    `DNI/CUIT` VARCHAR(20) NOT NULL,
    Telefono VARCHAR(20),
    Email VARCHAR(100),
    Rol VARCHAR(50),
    ID_Rol INT,
    PRIMARY KEY (Legajo),
    FOREIGN KEY (ID_Rol) REFERENCES roles(ID_Rol)
);

-- Tablas Principales

-- Clientes

CREATE TABLE clientes (
    ID_Cliente INT NOT NULL AUTO_INCREMENT,
    Nombre VARCHAR(45) NOT NULL,
    Apellido VARCHAR(45) NOT NULL,
    Direccion VARCHAR(45),
    Telefono VARCHAR(45),
    Email VARCHAR(45) NOT NULL,
    Documento VARCHAR(45) NOT NULL,
    PRIMARY KEY (ID_Cliente),
    UNIQUE KEY Documento_UNIQUE (Documento)
);

-- Proveedores

CREATE TABLE proveedores (
    ID_Proveedor INT NOT NULL AUTO_INCREMENT,
    Nombre VARCHAR(45) NOT NULL,
    Direccion VARCHAR(45) NOT NULL,
    Telefono VARCHAR(45) NOT NULL,
    Email VARCHAR(45),
    PRIMARY KEY (ID_Proveedor)
);

-- Productos

CREATE TABLE productos (
    ID_Producto INT NOT NULL AUTO_INCREMENT,
    Nombre VARCHAR(45),
    Descripcion TEXT,
    Precio DECIMAL(10,0),
    ID_Proveedor INT NOT NULL,
    Stock INT,
    PRIMARY KEY (ID_Producto)
);

-- Tablas de operaciones

-- Compras

CREATE TABLE compras (
    ID_Compras INT NOT NULL AUTO_INCREMENT,
    ID_Proveedor INT NOT NULL,
    Fecha DATE NOT NULL,
    Total DECIMAL(10,0) NOT NULL,
    Comprador INT UNSIGNED,
    PRIMARY KEY (ID_Compras),
    FOREIGN KEY (ID_Proveedor) REFERENCES proveedores(ID_Proveedor),
    FOREIGN KEY (Comprador) REFERENCES empleados(Legajo)
);

-- Ventas

CREATE TABLE ventas (
    ID_Ventas INT NOT NULL AUTO_INCREMENT,
    ID_Cliente INT NOT NULL,
    Fecha DATE NOT NULL,
    Total DECIMAL(10,0) NOT NULL,
    Medio_de_pago INT NOT NULL,
    Vendedor INT UNSIGNED,
    PRIMARY KEY (ID_Ventas),
    FOREIGN KEY (ID_Cliente) REFERENCES clientes(ID_Cliente) ON UPDATE CASCADE,
    FOREIGN KEY (Medio_de_pago) REFERENCES medios_de_pago(ID_Medio),
    FOREIGN KEY (Vendedor) REFERENCES empleados(Legajo)
);

-- Tablas intermedias

-- compras_productos

CREATE TABLE compras_productos (
    ID_Compras INT NOT NULL,
    ID_Producto INT NOT NULL,
    Cantidad INT NOT NULL,
    Precio_Unitario DECIMAL(10,0) NOT NULL,
    FOREIGN KEY (ID_Compras) REFERENCES compras(ID_Compras),
    FOREIGN KEY (ID_Producto) REFERENCES productos(ID_Producto)
);

-- ventas productos

CREATE TABLE ventas_productos (
    ID_Ventas INT NOT NULL,
    ID_Producto INT NOT NULL,
    Cantidad INT NOT NULL,
    Precio_Unitario DECIMAL(10,0) NOT NULL,
    FOREIGN KEY (ID_Ventas) REFERENCES ventas(ID_Ventas),
    FOREIGN KEY (ID_Producto) REFERENCES productos(ID_Producto)
);

-- Tablas de auditorías

-- auditoria_ventas

CREATE TABLE auditoria_ventas (
    ID_Auditoria INT NOT NULL AUTO_INCREMENT,
    ID_Ventas INT NOT NULL,
    Fecha DATE NOT NULL,
    ID_Cliente INT NOT NULL,
    Vendedor VARCHAR(100) NOT NULL,
    Medio_de_Pago VARCHAR(50) NOT NULL,
    Total DECIMAL(10,2) NOT NULL,
    Timestamp_Auditoria DATETIME DEFAULT CURRENT_TIMESTAMP,
    Origen_Auditoria VARCHAR(50) DEFAULT 'Trigger_Auto',
    PRIMARY KEY (ID_Auditoria),
    FOREIGN KEY (ID_Ventas) REFERENCES ventas(ID_Ventas),
    FOREIGN KEY (ID_Cliente) REFERENCES clientes(ID_Cliente)
);

-- auditoria_cuotas

CREATE TABLE auditoria_cuotas (
    ID_Auditoria INT NOT NULL AUTO_INCREMENT,
    ID_Cuota INT NOT NULL,
    ID_Venta INT NOT NULL,
    Monto_Cuota DECIMAL(10,2) NOT NULL,
    Fecha_Primer_Vencimiento DATE NOT NULL,
    Fecha_Registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (ID_Auditoria)
);

-- Inserción de Datos

-- Inserción de registros en la tabla `clientes`
INSERT INTO `clientes` 
VALUES
  (1, 'Comprador', 'Eventual', 'S/D', 'S/D', 'S/D', 'S/D'),
  (2, 'Mariana', 'Alvarez', 'Paraguay 123', '1151112222', 'Mar@hotmail.com', '25000002'),
  (3, 'Flavia N', 'Stein', 'Av Santa Fe 2423', '1153853651', 'Fla@connect.com', '23000001'),
  (4, 'Santiago', 'Gutierrez', 'Av. Cordoba 2344', '1151112222', 'San@gmail.com', '25000001'),
  (5, 'Rodrigo', 'Lucerna', 'Azquenaga 2253', '1145685642', 'peridiu@gom.com', '26995452'),
  (6, 'Romina', 'Benitez', 'Gasco 524', '1136985521', 'romi@landa.com', '32654252'),
  (7, 'Luciano', 'Periodo', 'Azquenaga 1882', '1156982571', 'luch@gmail.com', '24568452'),
  (8, 'Paula', 'Gutierrez', 'Av. Pueyredon 1235', '1135245879', 'pachi@gmail.com', '25521894'),
  (9, 'Pedro', 'Gonzalez', 'Arenales 1433', '1159325563', 'pedro@ola.com', '23654816'),
  (10, 'Laura', 'Molina', 'Arenales 1965', '1135623981', 'lala@hotmail.com', '25631587'),
  (11, 'Francisco', 'Molinari', 'Av. Cordoba 5624', '1128756851', 'franchute@gmail.com', '26254941');

-- Inserción de registros en la tabla `productos`
INSERT INTO productos (ID_Producto, Nombre, Descripcion, Precio, ID_Proveedor, Stock) 
VALUES
(1, 'RTX 4090', 'GPU insignia, Ada Lovelace, 24GB GDDR6X, 16384 núcleos CUDA, ideal para 4K, IA y edición profesional.', 1599, 1, 200),
(2, 'RTX 4080 SUPER', 'GPU de alto rendimiento, Ada Lovelace, 16GB GDDR6X, 10240 núcleos CUDA, excelente para gaming 4K y productividad', 999, 1, 300),
(3, 'RTX 4070 Ti SUPER', 'GPU para 1440p exigente, Ada Lovelace, 16GB GDDR6X, 8448 núcleos CUDA, buena relación rendimiento/precio.', 799, 1, 200),
(4, 'RTX 4070 SUPER', 'GPU de gama media-alta, Ada Lovelace, 12GB GDDR6X, 7168 núcleos CUDA, ideal para gaming competitivo.', 599, 1, 250),
(5, 'RTX 5090', 'GPU de ultra rendimiento, arquitectura Blackwell, 32GB GDDR7, 21760 núcleos CUDA, ideal para 4K extremo, IA y simulación.', 1999, 1, 150),
(6, 'RTX 5800', 'GPU de gama alta, Blackwell, 16GB GDDR7 a 30Gbps, 10752 núcleos CUDA, excelente para gaming 4K y creación de contenido.', 999, 1, 150),
(7, 'Radeon RX 7900 XTX', 'GPU de alta gama, arquitectura RDNA 3, 24GB GDDR6, ideal para gaming en 4K y tareas intensivas', 999, 7, 200),
(8, 'Radeon RX 7900 XT', 'GPU de alto rendimiento, RDNA 3, 20GB GDDR6, excelente para 1440p y 4K con buena eficiencia energética', 899, 7, 200),
(9, 'Radeon RX 7900 GRE', 'Versión optimizada para entornos profesionales y gaming exigente, RDNA 3, 16GB GDDR6.', 649, 7, 200),
(10, 'Radeon RX 7800 XT', 'GPU potente para 1440p, arquitectura RDNA 3, 16GB GDDR6, buena relación rendimiento/precio.', 499, 9, 150),
(11, 'Radeon RX 7800 XT', 'GPU potente para 1440p, arquitectura RDNA 3, 16GB GDDR6, buena relación rendimiento/precio.', 499, 10, 100),
(12, 'Radeon RX 7800 XT', 'GPU potente para 1440p, arquitectura RDNA 3, 16GB GDDR6, buena relación rendimiento/precio.', 499, 4, 100),
(13, 'Radeon RX 6950 XT', 'GPU tope de gama de la generación RDNA 2, 16GB GDDR6, excelente para 4K y productividad.', 699, 7, 120),
(14, 'Radeon RX 6900 XT', 'GPU de alto rendimiento, RDNA 2, 16GB GDDR6, gran capacidad para gaming en 4K.', 599, 9, 100),
(15, 'Radeon RX 6900 XT', 'GPU de alto rendimiento, RDNA 2, 16GB GDDR6, gran capacidad para gaming en 4K.', 599, 10, 50),
(16, 'Radeon RX 6900 XT', 'GPU de alto rendimiento, RDNA 2, 16GB GDDR6, gran capacidad para gaming en 4K.', 599, 4, 50),
(17, 'Radeon RX 9070 XT', 'GPU tope de gama RDNA 4, 64 unidades de procesamiento, 64GB GDDR6, aceleradores de rayos e IA de última generación, ideal para 4K y creación de contenido profesional.', 1199, 7, 120),
(18, 'Radeon RX 9070', 'GPU de alto rendimiento RDNA 4, 56 unidades de procesamiento, 16GB GDDR6, excelente para gaming en 4K y tareas exigentes con IA.', 899, 7, 100),
(19, 'Radeon RX 9060 XT', 'GPU potente para 1440p, RDNA 4, 32 unidades de procesamiento, 32GB GDDR6, buena relación rendimiento/precio con soporte para FSR 4', 649, 9, 40),
(20, 'Radeon RX 9060 XT', 'GPU potente para 1440p, RDNA 4, 32 unidades de procesamiento, 32GB GDDR6, buena relación rendimiento/precio con soporte para FSR 4', 649, 10, 30),
(21, 'Radeon RX 9060 XT', 'GPU potente para 1440p, RDNA 4, 32 unidades de procesamiento, 32GB GDDR6, buena relación rendimiento/precio con soporte para FSR 4', 649, 4, 30),
(22, 'RTX 5070 Ti', 'Rendimiento sólido en 1440p y 4K con DLSS 4 y trazado de rayos Gen 4.', 750, 2, 80),
(23, 'RTX 5070', 'Ideal para gaming competitivo en 1080p/1440p, con eficiencia y capacidades IA', 550, 2, 80),
(24, 'RTX 4070 Ti SUPER', 'Excelente para 1440p y 4K, con DLSS 3.5 y trazado de rayos Gen 3.', 750, 2, 80),
(25, 'RTX 4070 SUPER', 'Rendimiento sólido en 1440p, ideal para creadores y gamers exigentes.', 600, 2, 80),
(26, 'RTX 4070', 'Buena opción para gaming en 1080p/1440p con eficiencia energética', 550, 2, 80),
(27, 'RTX 5070 Ti', 'Rendimiento sólido en 1440p y 4K con DLSS 4 y trazado de rayos Gen 4.', 750, 3, 20),
(28, 'RTX 5070', 'Ideal para gaming competitivo en 1080p/1440p, con eficiencia y capacidades IA', 550, 3, 20),
(29, 'RTX 4070 Ti SUPER', 'Excelente para 1440p y 4K, con DLSS 3.5 y trazado de rayos Gen 3.', 750, 3, 20),
(30, 'RTX 4070 SUPER', 'Rendimiento sólido en 1440p, ideal para creadores y gamers exigentes.', 600, 3, 10),
(31, 'RTX 4070', 'Buena opción para gaming en 1080p/1440p con eficiencia energética', 550, 3, 30),
(32, 'RTX 5070 Ti', 'Rendimiento sólido en 1440p y 4K con DLSS 4 y trazado de rayos Gen 4.', 750, 4, 20),
(33, 'RTX 5070', 'Ideal para gaming competitivo en 1080p/1440p, con eficiencia y capacidades IA', 550, 4, 20),
(34, 'RTX 4070 Ti SUPER', 'Excelente para 1440p y 4K, con DLSS 3.5 y trazado de rayos Gen 3.', 750, 4, 20),
(35, 'RTX 4070 SUPER', 'Rendimiento sólido en 1440p, ideal para creadores y gamers exigentes.', 600, 4, 15),
(36, 'RTX 4070', 'Buena opción para gaming en 1080p/1440p con eficiencia energética', 550, 4, 10),
(37, 'Core Ultra 9 285HX', 'Procesador de alto rendimiento para portátiles gaming y estaciones móviles. 24 núcleos (8P + 16E), hasta 5.5 GHz, con NPU para IA y gráficos integrados Intel Arc. Ideal para multitarea extrema y creación de contenido.', 749, 6, 400),
(38, 'Core Ultra 9 285K', 'Versión de escritorio desbloqueada, con 24 núcleos y arquitectura Arrow Lake S. Potente para gaming 4K, edición de video y simulaciones complejas.', 720, 6, 400),
(39, 'Core i9-14900KS', 'Último modelo de Raptor Lake S, con 6.0 GHz de turbo. Excelente para overclocking y tareas exigentes, aunque sin NPU integrada.', 699, 6, 400),
(40, 'Core Ultra 5 235A', '14 núcleos (6P + 8E), ideal para gaming en 1080p/1440p y productividad diaria. Arquitectura Arrow Lake con eficiencia energética y soporte IA.', 299, 8, 300),
(41, 'Core Ultra 5 235TA', 'Variante optimizada para portátiles, con buen rendimiento multihilo y gráficos integrados. Perfecto para usuarios que buscan equilibrio.', 279, 8, 300),
(42, 'Core Ultra 5 235UA', 'Chip compacto con núcleos de bajo consumo (LP-E), pensado para laptops livianas y tareas cotidianas con IA integrada.', 259, 8, 300),
(43, 'Ryzen Threadripper 9980X', '64 núcleos y 128 hilos, diseñado para estaciones de trabajo, renderizado 3D, simulaciones y cargas masivas. Arquitectura Zen 5.', 1499, 7, 300),
(44, 'Ryzen 9 9950X3D', '16 núcleos con tecnología 3D V-Cache de segunda generación. Ideal para gaming extremo y creación de contenido con baja latencia.', 749, 7, 300),
(45, 'Ryzen 9 9950X', 'Versión sin V-Cache, pero con gran potencia para tareas exigentes. Turbo de hasta 5.7 GHz y excelente rendimiento multihilo.', 699, 7, 300),
(46, 'Ryzen 7 9700F', '8 núcleos, sin gráficos integrados, pensado para gamers y creadores que usan GPU dedicada. Zen 5 con buen rendimiento por dólar.', 349, 12, 300),
(47, 'Ryzen 7 7700X', 'Zen 4, 8 núcleos, ideal para gaming en 1440p y edición ligera. Buen balance entre precio y potencia.', 319, 12, 300),
(48, 'Ryzen 5 7600X', '6 núcleos, turbo de 5.3 GHz, excelente para gaming en 1080p y tareas generales. Muy eficiente y competitivo.', 269, 12, 300),
(49, 'ASUS ROG Maximus Z890 Hero', 'ATX, socket LGA1851, DDR5 hasta 9200 MHz, 6x M.2, Wi-Fi 7, Thunderbolt 4, ideal para overclocking y gaming extremo.', 659, 8, 600),
(50, 'Gigabyte Z890 AORUS Master', 'ATX, LGA1851, DDR5 hasta 9500 MHz, 5x M.2, red 10 GbE, AI Snatch para optimización automática. Potente y elegante.', 599, 5, 600),
(51, 'ASUS ROG Crosshair X870E Hero', 'ATX, socket AM5, DDR5, PCIe 5.0, Wi-Fi 7, ideal para Ryzen 9000 y setups de alto rendimiento', 663, 8, 500),
(52, 'MSI Pro B650M-P', 'Micro-ATX, socket AM5, DDR5, PCIe 4.0, LAN 2.5Gb, ideal para Ryzen 7000 y 8000. Moderna y accesible.', 129, 4, 700),
(53, 'ASUS Prime B760M-K D4', 'Micro-ATX, LGA1700, DDR4, USB 3.2 Gen 1, buena opción para Intel 12ª y 13ª Gen. Estable y compacta.', 109, 8, 700),
(54, 'GIGABYTE B550M K', 'Micro-ATX, socket AM4, PCIe 4.0, Dual M.2, excelente calidad-precio para Ryzen 5000.', 89, 5, 700),
(55, 'Kingston Fury Beast DDR4 3200MHz', 'Módulo UDIMM DDR4, 16GB, frecuencia 3200MHz, CL16, voltaje 1.35V, ideal para gaming y productividad.', 75, 13, 800),
(56, 'Hiksemi Armor DDR4 3200MHz', 'Módulo UDIMM DDR4, 16GB, frecuencia 3200MHz, voltaje 1.2V, buena opción para PCs de gama media.', 60, 13, 800),
(57, 'Corsair Vengeance RGB Pro DDR4 3600MHz', 'Módulo UDIMM DDR4, 16GB, frecuencia 3600MHz, RGB, ideal para setups gamer con estética personalizada.', 108, 13, 700),
(58, 'Kingston Fury Beast DDR4 3200MHz RGB', 'Módulo UDIMM DDR4, 32GB, frecuencia 3200MHz, RGB, voltaje 1.2V, excelente para multitarea y gaming avanzado.', 153, 12, 650),
(59, 'Corsair Vengeance DDR5 6000MHz RGB', 'Kit 2x16GB DDR5, frecuencia 6000MHz, CL36, RGB, compatible con Intel y AMD EXPO. Ideal para setups de alto rendimiento.', 185, 12, 650),
(60, 'Lexar LD4AS032G-B3200GSST DDR4 3200MHz', 'Módulo UDIMM DDR4, 32GB, frecuencia 3200MHz, voltaje 1.2V, buena opción para productividad y gaming moderado.', 129, 12, 650),
(61, 'Kingston NV2 SNV2S/1000G – 1TB', 'SSD M.2 NVMe PCIe 4.0, velocidad de lectura hasta 3500MB/s. Ideal para notebooks y PCs modernas.', 114, 13, 800),
(62, 'Western Digital SN350 Green – 1TB', 'SSD M.2 NVMe PCIe Gen3, lectura hasta 2400MB/s. Excelente relación precio-rendimiento.', 95, 13, 800),
(63, 'Hiksemi Future Lite – 2TB', 'SSD M.2 PCIe Gen4 x4, lectura ultra rápida, ideal para cargas pesadas y multitarea.', 181, 13, 800),
(64, 'Kingston Fury Renegade 2TB NVMe PCIe Gen4', 'Velocidad de lectura/escritura de hasta 7300/7000 MB/s. Ideal para gaming extremo y edición profesional. Compatible con PS5.', 350, 12, 600),
(65, 'Hiksemi Future X Lite 2TB Gen', 'SSD NVMe Gen4 x4, lectura hasta 7100MB/s. Disipador incluido. Excelente para multitarea intensiva.', 230, 12, 600),
(66, 'Kingston NV2 Gen4 4TB SNV2S/4000G', 'Interfaz PCIe 4.0 x4, lectura hasta 3500MB/s. Gran capacidad para almacenamiento masivo con eficiencia térmica.', 440, 12, 600),
(67, 'ADATA XPG MARS 980 Blade Gen5 4TB', 'PCIe Gen5 x4, lectura hasta 14.000MB/s, escritura hasta 13.000MB/s. Rendimiento extremo para entornos exigentes.', 542, 12, 600),
(68, 'MacBook Air M2 (13")', 'Ultraliviana, con chip M2, ideal para estudiantes, profesionales móviles y tareas creativas ligeras. Excelente autonomía y diseño minimalista.', 1800, 14, 50),
(69, 'MacBook Pro M3 (14")', 'Potencia profesional con chip M3, pantalla Liquid Retina XDR, ideal para edición de video, programación y diseño gráfico exigente.', 2700, 14, 50),
(70, 'MacBook Air M4 (13.6")', 'Última generación con chip M4, 16GB RAM, SSD de 512GB. Rendimiento mejorado y diseño refinado. Perfecta para multitarea y portabilidad.', 1700, 14, 50),
(71, 'MacBook Pro M1 Max (16")', 'Chip M1 Max, 32GB RAM, SSD de 1TB. Rendimiento extremo para edición 4K, modelado 3D y flujos de trabajo pesados.', 2999, 14, 10);


-- Inserción de registros en la tabla `proveedores`
INSERT INTO `proveedores` 
VALUES
  (1, 'NVIDIA', 'Gorostiaga 6532', '1156981482', 'ventas@nvidia.com'),
  (2, 'EVGA', 'Bolivar 4563', '1135698347', 'ventas@evga.com'),
  (3, 'Zontac', 'Lima 1234', '1156985273', 'ventas@zontac.com'),
  (4, 'MSI', 'Av. Las Heras 2345', '1142841258', 'ventas@msi.com'),
  (5, 'Gigabyte', 'Lima 322', '1154218519', 'ventas@gigabyte.com'),
  (6, 'Intel', 'Av. Carabobo 2536', '1142851951', 'venta@intel.com'),
  (7, 'AMD', 'Av. Las Heras 252', '1139542571', 'ventas@amd.com'),
  (8, 'ASUS', 'Rodriguez Peña 195', '1145631842', 'ventas@asus.com'),
  (9, 'Sapphire', 'Lima 135', '1162158521', 'ventas@Sapphire.com'),
  (10, 'Biostar', 'Av. Cordoba 235', '1162587126', 'ventas@biostar.com'),
  (11, 'ASRock', 'Av. Rivadavia 2541', '1157153647', 'ventas@ASRock.com'),
  (12, 'IBM', 'Lima 235', '1167153647', 'ventas@ibm.com'),
  (13, 'Texas Instruments', 'Av. Carabobo 652', '1137429841', 'ventas@texa.com'),
  (14, 'Apple', 'Av. Rivadavia 561', '1145317824', 'ventas@apple.com');


-- Inserción de registros en la tabla `medios_de_pago`
INSERT INTO `medios_de_pago` 
VALUES
  (1, 'Efectivo', 'Contado', 0),
  (2, 'Tarjeta Debito', 'Contado', 0),
  (3, 'Visa', NULL, 0),
  (4, 'Masterd Card', NULL, 0),
  (5, 'American Express', 'Crédito', 1),
  (6, 'Modo / Mercado Pago', 'Crédito', 1);


-- Inserción de registros en la tabla `cuotas_pago`
INSERT INTO `cuotas_pago` 
VALUES
  (1,5,1),
  (2,5,3),
  (3,5,6),
  (4,6,1),
  (5,6,3),
  (6,6,6);


-- Inserción de registros en la tabla `roles`
INSERT INTO `roles` 
VALUES
  (2, 'Socio Gerente', 'Socio con facultades ejecutivas que representa legal y operativamente a la empresa.'),
  (3, 'Vendedor', 'Responsable de ofrecer productos, cerrar ventas y cultivar relaciones comerciales.'),
  (4, 'Compras y Deposito', 'Gestiona la adquisición, recepción y almacenamiento de productos, asegurando abastecimiento eficiente, control de inventario y trazabilidad operativa.'),
  (5, 'Capital Humano', 'Supervisa el desempeño individual, gestiona vínculos laborales y promueve el desarrollo estratégico del talento dentro de la organización.');

-- Inserción de registros en la tabla `empleados`
INSERT INTO `empleados` 
VALUES
  (2, 'Lammen Rosgoniel', '27255554239', '1151774780', 'LammenRos@Chuchuflito.com', 'Socio Gerente', 2),
  (3, 'Vendedor 1', '27333333339', '2215745852', 'vendedor1@Cuchuflito.com', 'Vendedor', 3),
  (4, 'Vendedor 2', '24135555469', '1154794545', 'vendedor2@Cuchuflito.com', 'Vendedor', 3),
  (5, 'Vendedor 3', '24134555589', '1151135555', 'vendedor3@Cuchuflito.com', 'Vendedor', 3),
  (6, 'Compras', '27235555559', '1151125555', 'compras@Cuchuflito.com', 'Compras y Deposito', 4);


-- Inserción de registros en la tabla `compras`
INSERT INTO `compras` 
VALUES
  (2, 1, '2025-08-01', 1378750, 2),
  (3, 2, '2025-08-01', 256000, 2),
  (4, 3, '2025-08-01', 63500, 4),
  (5, 4, '2025-08-01', 245120, 2),
  (6, 5, '2025-08-01', 421700, 2),
  (7, 6, '2025-08-01', 867200, 2),
  (8, 7, '2025-08-01', 1711600, 2),
  (9, 8, '2025-08-01', 1054300, 4),
  (10, 9, '2025-08-01', 160710, 2),
  (11, 10, '2025-08-01', 99320, 4),
  (12, 12, '2025-08-01', 1521850, 2),
  (13, 13, '2025-08-01', 495600, 4),
  (14, 14, '2025-08-01', 339990, 4);


-- Inserción de registros en la tabla `compras_productos`
INSERT INTO `compras_productos` 
VALUES
(2,1,200,1599),(2,2,300,999),(2,3,200,799),(2,4,250,599),(2,5,150,1999),(2,6,150,999),
(3,22,80,750),(3,23,80,550),(3,24,80,750),(3,25,80,600),(3,26,80,550),
(2,1,200,1599),(2,2,300,999),(2,3,200,799),(2,4,250,599),(2,5,150,1999),(2,6,150,999),
(3,22,80,750),(3,23,80,550),(3,24,80,750),(3,25,80,600),(3,26,80,550),
(4,27,20,750),(4,28,20,550),(4,29,20,750),(4,30,10,600),(4,31,30,550),
(5,12,100,499),(5,16,50,599),(5,21,30,649),(5,32,20,750),(5,33,20,550),
(5,34,20,750),(5,35,15,600),(5,36,10,550),(5,52,700,129),
(6,50,600,599),(6,54,700,89),
(7,37,400,749),(7,38,400,720),(7,39,400,699),
(8,7,200,999),(8,8,200,899),(8,9,200,649),(8,13,120,699),(8,17,120,1199),
(8,18,100,899),(8,43,300,1499),(8,44,300,749),(8,45,300,699),
(9,40,300,299),(9,41,300,279),(9,42,300,259),(9,49,600,659),(9,51,500,663),(9,53,700,109),
(10,10,150,499),(10,14,100,599),(10,19,40,649),
(11,11,100,499),(11,15,50,599),(11,20,30,649),
(12,46,300,349),(12,47,300,319),(12,48,300,269),(12,58,650,153),(12,59,650,185),
(12,60,650,129),(12,64,600,350),(12,65,600,230),(12,66,600,440),(12,67,600,542),
(13,55,800,75),(13,56,800,60),(13,57,700,108),(13,61,800,114),(13,62,800,95),(13,63,800,181),
(14,68,50,1800),(14,69,50,2700),(14,70,50,1700),(14,71,50,2999),
(2,1,200,1599),(2,2,300,999),(2,3,200,799),(2,4,250,599),(2,5,150,1999),(2,6,150,999),
(3,22,80,750),(3,23,80,550),(3,24,80,750),(3,25,80,600),(3,26,80,550),
(4,27,20,750),(4,28,20,550),(4,29,20,750),(4,30,10,600),(4,31,30,550),
(5,12,100,499),(5,16,50,599),(5,21,30,649),(5,32,20,750),(5,33,20,550),
(5,34,20,750),(5,35,15,600),(5,36,10,550),(5,52,700,129),
(6,50,600,599),(6,54,700,89),
(7,37,400,749),(7,38,400,720),(7,39,400,699),
(8,7,200,999),(8,8,200,899),(8,9,200,649),(8,13,120,699),(8,17,120,1199),
(8,18,100,899),(8,43,300,1499),(8,44,300,749),(8,45,300,699),
(9,40,300,299),(9,41,300,279),(9,42,300,259),(9,49,600,659),(9,51,500,663),(9,53,700,109),
(10,10,150,499),(10,14,100,599),(10,19,40,649),
(11,11,100,499),(11,15,50,599),(11,20,30,649),
(12,46,300,349),(12,47,300,319),(12,48,300,269),(12,58,650,153),(12,59,650,185),
(12,60,650,129),(12,64,600,350),(12,65,600,230),(12,66,600,440),(12,67,600,542),
(13,55,800,75),(13,56,800,60),(13,57,700,108),(13,61,800,114),(13,62,800,95),(13,63,800,181),
(14,68,50,1800),(14,69,50,2700),(14,70,50,1700),(14,71,50,2999);


-- Inserción de registros en la tabla `ventas`
INSERT INTO `ventas` 
VALUES
  (1, 1, '2025-08-03', 2999, 6, 3),
  (2, 1, '2025-08-03', 1599, 3, 3),
  (3, 3, '2025-08-03', 699, 5, 4),
  (4, 2, '2025-08-29', 3998, 2, 2),
  (5, 3, '2025-08-29', 3996, 2, 3),
  (6, 4, '2025-08-29', 2599, 6, 4),
  (7, 4, '2025-08-29', 2599, 3, 4),
  (8, 5, '2025-09-01', 3219,2, 5),
  (9, 6, '2025-09-01', 1084, 1, 3),
  (10, 1, '2025-09-03', 2298, 3, 5),
  (11, 9, '2025-09-05', 1698, 2, 4),
  (12, 8, '2025-09-05', 899, 1, 3),
  (13, 1, '2025-09-05', 150, 3, 5),
  (14, 2, '2025-09-06', 1700, 5, 3),
  (15, 1, '2025-09-06', 2646, 5, 2),
  (16, 5, '2025-09-06', 999, 4, 4);

-- Inserción de registros en la tabla `ventas_productos`
INSERT INTO `ventas_productos` 
VALUES
  (1, 71, 1, 2999),
  (2, 1, 1, 1599),
  (3, 13, 1, 699),
  (4, 5, 2, 1999),
  (5, 6, 4, 999),
  (6, 71, 1, 2599),
  (7, 71, 1, 2599),
  (8, 1, 1, 1599),
  (8, 39, 1, 699),
  (8, 51, 1, 663),
  (8, 60, 2, 258),
  (9, 67, 2, 1084),
  (10, 5, 1, 1999),
  (10, 40, 1, 299),
  (11, 43, 1, 1499),
  (11, 62, 2, 190),
  (12, 18, 1, 899),
  (13, 55, 2, 150),
  (14, 70, 1, 1700),
  (15, 18, 1, 899),
  (15, 43, 1, 1499),
  (15, 58, 1, 153),
  (15, 62, 1, 95),
  (16, 7, 1, 999);

  
-- Vistas del sistema

-- vista_compras_detalladas

CREATE VIEW vista_compras_detalladas AS
SELECT
    c.ID_Compras AS ID_Compras,
    c.Fecha AS Fecha,
    pr.Nombre AS Producto,
    cp.Cantidad AS Cantidad,
    cp.Precio_Unitario AS Precio_Unitario,
    prov.Nombre AS Proveedor,
    prov.Email AS Email
FROM compras c
JOIN compras_productos cp ON c.ID_Compras = cp.ID_Compras
JOIN productos pr ON cp.ID_Producto = pr.ID_Producto
JOIN proveedores prov ON c.ID_Proveedor = prov.ID_Proveedor;

-- vista_compras_facturadas

CREATE VIEW vista_compras_facturadas AS
SELECT
    c.ID_Compras AS ID_compras,
    c.Fecha AS Fecha,
    p.Nombre AS Nombre_Proveedor,
    c.Total AS Total_Facturado
FROM compras c
JOIN proveedores p ON c.ID_Proveedor = p.ID_Proveedor;

-- vista_control_inventario 

CREATE VIEW vista_control_inventario AS
SELECT
    p.ID_Producto AS ID_Producto,
    p.Nombre AS Nombre,
    p.Descripcion AS Descripcion,
    p.Stock AS stock_actual,
    IFNULL(SUM(cp.Cantidad), 0) AS total_comprado,
    IFNULL(SUM(vp.Cantidad), 0) AS total_vendido,
    ((p.Stock + IFNULL(SUM(vp.Cantidad), 0)) - IFNULL(SUM(cp.Cantidad), 0)) AS stock_recalculado
FROM productos p
LEFT JOIN compras_productos cp ON p.ID_Producto = cp.ID_Producto
LEFT JOIN ventas_productos vp ON p.ID_Producto = vp.ID_Producto
GROUP BY p.ID_Producto, p.Nombre, p.Descripcion, p.Stock;

-- vista_inventario_por_proveedor

CREATE VIEW vista_inventario_por_proveedor AS
SELECT
    pr.ID_Proveedor AS ID_Proveedor,
    pr.Nombre AS nombre_proveedor,
    p.ID_Producto AS ID_Producto,
    p.Nombre AS nombre_producto,
    p.Descripcion AS Descripcion,
    IFNULL(SUM(cp.Cantidad), 0) AS total_comprado,
    IFNULL(SUM(vp.Cantidad), 0) AS total_vendido,
    p.Stock AS stock_actual,
    ((p.Stock + IFNULL(SUM(vp.Cantidad), 0)) - IFNULL(SUM(cp.Cantidad), 0)) AS stock_recalculado
FROM productos p
LEFT JOIN compras_productos cp ON p.ID_Producto = cp.ID_Producto
LEFT JOIN compras c ON cp.ID_Compras = c.ID_Compras
LEFT JOIN proveedores pr ON c.ID_Proveedor = pr.ID_Proveedor
LEFT JOIN ventas_productos vp ON p.ID_Producto = vp.ID_Producto
GROUP BY pr.ID_Proveedor, pr.Nombre, p.ID_Producto, p.Nombre, p.Descripcion, p.Stock;

-- vista_productos_agrupados

CREATE VIEW vista_productos_agrupados AS
SELECT
    productos.Nombre AS Nombre,
    SUM(productos.Stock) AS stock_total,
    GROUP_CONCAT(DISTINCT productos.Descripcion SEPARATOR '; ') AS descripciones,
    GROUP_CONCAT(DISTINCT productos.Precio SEPARATOR '; ') AS costos
FROM productos
GROUP BY productos.Nombre;

-- vista_ventas_detalladas

CREATE VIEW vista_ventas_detalladas AS
SELECT
    v.ID_Ventas AS ID_Ventas,
    v.Fecha AS Fecha,
    p.Nombre AS Producto,
    vp.Cantidad AS Cantidad,
    vp.Precio_Unitario AS Precio_Unitario,
    mp.Medio_de_Pago AS Medio_de_Pago,
    c.Nombre AS Cliente,
    c.Apellido AS Apellido_Cliente
FROM ventas v
JOIN ventas_productos vp ON v.ID_Ventas = vp.ID_Ventas
JOIN productos p ON vp.ID_Producto = p.ID_Producto
JOIN medios_de_pago mp ON v.Medio_de_pago = mp.ID_Medio
JOIN clientes c ON v.ID_Cliente = c.ID_Cliente;

-- resumen_ventas_por_vendedor

CREATE VIEW resumen_ventas_por_vendedor AS
SELECT 
  e.Legajo AS ID_Vendedor,
  e.Nombre_completo,
  COUNT(v.ID_Ventas) AS Cantidad_Ventas,
  SUM(v.Total) AS Monto_Total_Vendido
FROM ventas v
JOIN empleados e ON v.Vendedor = e.Legajo
GROUP BY e.Legajo, e.Nombre_completo;

-- Funciones del sistema

-- calcular_total_compra

DELIMITER //

CREATE FUNCTION calcular_total_compra(id_compra INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(Cantidad * Precio_Unitario)
    INTO total
    FROM compras_productos
    WHERE ID_Compras = id_compra;
    RETURN total;
END;
//

DELIMITER ;

-- calcular_total_venta

DELIMITER //

CREATE FUNCTION calcular_total_venta(id_venta INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(Cantidad * Precio_Unitario)
    INTO total
    FROM ventas_productos
    WHERE ID_Ventas = id_venta;
    RETURN total;
END;
//

DELIMITER ;

-- stock_actual_producto

DELIMITER //

CREATE FUNCTION stock_actual_producto(id_producto INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE stock_actual INT;
    SELECT Stock
    INTO stock_actual
    FROM productos
    WHERE ID_Producto = id_producto;
    RETURN stock_actual;
END;
//

DELIMITER ;

-- total_facturado_cliente

DELIMITER //

CREATE FUNCTION total_facturado_cliente(id_cliente INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(Total)
    INTO total
    FROM ventas
    WHERE ID_Cliente = id_cliente;
    RETURN total;
END;
//

DELIMITER ;

-- Stored Procedures

-- Procedimiento registrar_compra

DELIMITER //

CREATE PROCEDURE registrar_compra (
    IN proveedor_id INT,
    IN fecha_compra DATE,
    IN total_compra DECIMAL(10,2),
    IN comprador_id INT
)
BEGIN
    INSERT INTO compras (ID_Proveedor, Fecha, Total, Comprador)
    VALUES (proveedor_id, fecha_compra, total_compra, comprador_id);
END;
//

DELIMITER ;

-- Procedimiento registrar_venta

DELIMITER //

CREATE PROCEDURE registrar_venta (
    IN cliente_id INT,
    IN medio_pago_id INT,
    IN vendedor_id INT,
    IN producto_id INT,
    IN cantidad INT,
    IN precio_unitario DECIMAL(10,2)
)
BEGIN
    DECLARE nueva_venta_id INT;

    -- Registrar la venta
    INSERT INTO ventas (ID_Cliente, Medio_de_pago, Vendedor, Fecha, Total)
    VALUES (cliente_id, medio_pago_id, vendedor_id, NOW(), cantidad * precio_unitario);

    -- Obtener el ID de la venta recién creada
    SET nueva_venta_id = LAST_INSERT_ID();

    -- Registrar el producto vendido
    INSERT INTO ventas_productos (ID_Ventas, ID_Producto, Cantidad, Precio_Unitario)
    VALUES (nueva_venta_id, producto_id, cantidad, precio_unitario);
END;
//

DELIMITER ;

-- Procedimiento actualizar_stock

DELIMITER //

CREATE PROCEDURE actualizar_stock (
    IN producto_id INT,
    IN cantidad INT
)
BEGIN
    UPDATE productos
    SET Stock = Stock + cantidad
    WHERE ID_Producto = producto_id;
END;
//

DELIMITER ;

-- Procedimiento registrar_cuota

DELIMITER //

CREATE PROCEDURE registrar_cuota (
    IN medio_id INT,
    IN cantidad_cuotas INT
)
BEGIN
    INSERT INTO cuotas_pago (ID_Medio, Cantidad_Cuotas)
    VALUES (medio_id, cantidad_cuotas);
END;
//

DELIMITER ;

-- Procedimiento ObtenerResumenComprasPorEmpleado

DELIMITER //

CREATE PROCEDURE ObtenerResumenComprasPorEmpleado()
BEGIN
    SELECT 
        e.Nombre_Completo AS Nombre_Empleado,
        COUNT(c.Comprador) AS Cantidad_Compras,
        SUM(c.Total) AS Monto_Total,
        AVG(c.Total) AS Promedio_Compra
    FROM compras c
    INNER JOIN empleados e ON c.Comprador = e.Legajo
    GROUP BY e.Nombre_Completo;
END;
//

DELIMITER ;

-- Procedimiento ObtenerResumenVentasPorEmpleado

DELIMITER //

CREATE PROCEDURE ObtenerResumenVentasPorEmpleado()
BEGIN
    SELECT 
        e.Nombre_Completo AS Nombre_Empleado,
        COUNT(v.Vendedor) AS Cantidad_Ventas,
        SUM(v.Total) AS Monto_Total,
        AVG(v.Total) AS Promedio_Venta
    FROM ventas v
    INNER JOIN empleados e ON v.Vendedor = e.Legajo
    GROUP BY e.Nombre_Completo;
END;
//

DELIMITER ;

-- Procedimiento registrar_venta_update

DELIMITER //

CREATE PROCEDURE registrar_venta_update (
    IN cliente_id INT,
    IN medio_pago_id INT,
    IN vendedor_id INT,
    IN producto_id INT,
    IN cantidad INT,
    IN precio_unitario DECIMAL(10,2)
)
BEGIN
    DECLARE nueva_venta_id INT;
    DECLARE stock_actual INT DEFAULT 0;

    -- Verificar stock disponible del producto solicitado
    SELECT Stock INTO stock_actual
    FROM productos
    WHERE ID_Producto = producto_id;

    IF stock_actual < cantidad THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock insuficiente para concretar la venta.';
    ELSE
        -- Registrar la venta
        INSERT INTO ventas (ID_Cliente, Medio_de_pago, Vendedor, Fecha, Total)
        VALUES (cliente_id, medio_pago_id, vendedor_id, NOW(), cantidad * precio_unitario);

        -- Obtener el ID de la venta recién creada
        SET nueva_venta_id = LAST_INSERT_ID();

        -- Registrar el producto vendido
        INSERT INTO ventas_productos (ID_Ventas, ID_Producto, Cantidad, Precio_Unitario)
        VALUES (nueva_venta_id, producto_id, cantidad, precio_unitario);

        -- Actualizar el stock del producto
        UPDATE productos
        SET Stock = Stock - cantidad
        WHERE ID_Producto = producto_id;
    END IF;
END;
//

DELIMITER ;


-- Creación de usuarios según roles institucionales (sin clave)

-- Usuario: Socio Gerente
DROP USER IF EXISTS 'socio_gerente_user'@'localhost';
CREATE USER 'socio_gerente_user'@'localhost';

-- Acceso total sobre todas las tablas (crear, modificar, eliminar, consultar, insertar, actualizar)
GRANT ALL PRIVILEGES ON cuchuflito_sa.* TO 'socio_gerente_user'@'localhost';

-- Permisos para crear y modificar estructuras
GRANT CREATE, ALTER, DROP ON cuchuflito_sa.* TO 'socio_gerente_user'@'localhost';

-- Permisos para consultar todas las vistas
GRANT SELECT ON cuchuflito_sa.vista_compras_detalladas TO 'socio_gerente_user'@'localhost';
GRANT SELECT ON cuchuflito_sa.vista_compras_facturadas TO 'socio_gerente_user'@'localhost';
GRANT SELECT ON cuchuflito_sa.vista_control_inventario TO 'socio_gerente_user'@'localhost';

-- Permisos para ejecutar todas las funciones
GRANT EXECUTE ON FUNCTION calcular_total_venta TO 'socio_gerente_user'@'localhost';
GRANT EXECUTE ON FUNCTION calcular_total_compra TO 'socio_gerente_user'@'localhost';
GRANT EXECUTE ON FUNCTION stock_actual_producto TO 'socio_gerente_user'@'localhost';
GRANT EXECUTE ON FUNCTION total_facturado_cliente TO 'socio_gerente_user'@'localhost';

-- Permisos para ejecutar todos los procedimientos
GRANT EXECUTE ON PROCEDURE registrar_venta TO 'socio_gerente_user'@'localhost';
GRANT EXECUTE ON PROCEDURE registrar_venta_update TO 'socio_gerente_user'@'localhost';
GRANT EXECUTE ON PROCEDURE registrar_compra TO 'socio_gerente_user'@'localhost';
GRANT EXECUTE ON PROCEDURE actualizar_stock TO 'socio_gerente_user'@'localhost';
GRANT EXECUTE ON PROCEDURE registrar_cuota TO 'socio_gerente_user'@'localhost';
GRANT EXECUTE ON PROCEDURE ObtenerResumenComprasPorEmpleado TO 'socio_gerente_user'@'localhost';
GRANT EXECUTE ON PROCEDURE ObtenerResumenVentasPorEmpleado TO 'socio_gerente_user'@'localhost';

-- Usuario: Vendedor
DROP USER IF EXISTS 'vendedor_user'@'localhost';
CREATE USER 'vendedor_user'@'localhost';

-- Permisos de inserción en tablas de ventas
GRANT INSERT ON cuchuflito_sa.ventas TO 'vendedor_user'@'localhost';
GRANT INSERT ON cuchuflito_sa.ventas_productos TO 'vendedor_user'@'localhost';

-- Permisos de consulta en tabla de clientes (solo si necesita validar antes de vender)
GRANT SELECT ON cuchuflito_sa.clientes TO 'vendedor_user'@'localhost';

-- Permisos de consulta en vistas relacionadas con ventas
GRANT SELECT ON cuchuflito_sa.vista_ventas_detalladas TO 'vendedor_user'@'localhost';
GRANT SELECT ON cuchuflito_sa.vista_productos_agrupados TO 'vendedor_user'@'localhost';

-- Permisos de ejecución en funciones relacionadas con ventas
GRANT EXECUTE ON FUNCTION calcular_total_venta TO 'vendedor_user'@'localhost';

-- Permisos de ejecución en procedimientos relacionados con ventas
GRANT EXECUTE ON PROCEDURE registrar_venta TO 'vendedor_user'@'localhost';
GRANT EXECUTE ON PROCEDURE registrar_venta_update TO 'vendedor_user'@'localhost';
GRANT EXECUTE ON PROCEDURE ObtenerResumenVentasPorEmpleado TO 'vendedor_user'@'localhost';

-- Usuario: Compras y Depósito
DROP USER IF EXISTS 'compras_deposito_user'@'localhost';
CREATE USER 'compras_deposito_user'@'localhost';

-- Permisos de inserción en tablas operativas
GRANT INSERT ON cuchuflito_sa.compras TO 'compras_deposito_user'@'localhost';
GRANT INSERT ON cuchuflito_sa.compras_productos TO 'compras_deposito_user'@'localhost';

-- Permisos de inserción y consulta en proveedores
GRANT INSERT ON cuchuflito_sa.proveedores TO 'compras_deposito_user'@'localhost';
GRANT SELECT ON cuchuflito_sa.proveedores TO 'compras_deposito_user'@'localhost';

-- Permisos de consulta en vistas relacionadas con compras y stock
GRANT SELECT ON cuchuflito_sa.vista_compras_detalladas TO 'compras_deposito_user'@'localhost';
GRANT SELECT ON cuchuflito_sa.vista_compras_facturadas TO 'compras_deposito_user'@'localhost';
GRANT SELECT ON cuchuflito_sa.vista_control_inventario TO 'compras_deposito_user'@'localhost';

-- Permisos de ejecución en funciones de compras
GRANT EXECUTE ON FUNCTION calcular_total_compra TO 'compras_deposito_user'@'localhost';

-- Permisos de ejecución en procedimientos de compras y depósito
GRANT EXECUTE ON PROCEDURE registrar_compra TO 'compras_deposito_user'@'localhost';
GRANT EXECUTE ON PROCEDURE actualizar_stock TO 'compras_deposito_user'@'localhost';

-- Usuario: Capital Humano
DROP USER IF EXISTS 'capital_humano_user'@'localhost';
CREATE USER 'capital_humano_user'@'localhost';

-- Permisos de lectura y edición sobre todas las tablas (sin INSERT ni DELETE)
GRANT SELECT, UPDATE ON cuchuflito_sa.empleados TO 'capital_humano_user'@'localhost';
GRANT SELECT, UPDATE ON cuchuflito_sa.medios_de_pago TO 'capital_humano_user'@'localhost';
GRANT SELECT, UPDATE ON cuchuflito_sa.roles TO 'capital_humano_user'@'localhost';
GRANT SELECT, UPDATE ON cuchuflito_sa.cuotas_pago TO 'capital_humano_user'@'localhost';
GRANT SELECT, UPDATE ON cuchuflito_sa.ventas TO 'capital_humano_user'@'localhost';
GRANT SELECT, UPDATE ON cuchuflito_sa.ventas_productos TO 'capital_humano_user'@'localhost';
GRANT SELECT, UPDATE ON cuchuflito_sa.compras TO 'capital_humano_user'@'localhost';
GRANT SELECT, UPDATE ON cuchuflito_sa.productos TO 'capital_humano_user'@'localhost';
GRANT SELECT, UPDATE ON cuchuflito_sa.compras_productos TO 'capital_humano_user'@'localhost';
GRANT SELECT, UPDATE ON cuchuflito_sa.proveedores TO 'capital_humano_user'@'localhost';
GRANT SELECT, UPDATE ON cuchuflito_sa.clientes TO 'capital_humano_user'@'localhost';

-- Acceso de solo lectura a todas las vistas
GRANT SELECT ON cuchuflito_sa.resumen_ventas_por_vendedor TO 'capital_humano_user'@'localhost';
GRANT SELECT ON cuchuflito_sa.vista_inventario_por_proveedor TO 'capital_humano_user'@'localhost';
GRANT SELECT ON cuchuflito_sa.vista_productos_agrupados TO 'capital_humano_user'@'localhost';
GRANT SELECT ON cuchuflito_sa.vista_compras_detalladas TO 'capital_humano_user'@'localhost';
GRANT SELECT ON cuchuflito_sa.vista_compras_facturadas TO 'capital_humano_user'@'localhost';
GRANT SELECT ON cuchuflito_sa.vista_control_inventario TO 'capital_humano_user'@'localhost';
GRANT SELECT ON cuchuflito_sa.vista_ventas_detalladas TO 'capital_humano_user'@'localhost';

-- No se conceden permisos de INSERT, DELETE, EXECUTE, CREATE, DROP ni ALTER
