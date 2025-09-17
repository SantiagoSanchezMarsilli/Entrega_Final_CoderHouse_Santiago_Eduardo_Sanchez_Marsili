-- Selección de la base de datos para trabajar
USE Cuchuflito_SA;

-- Creacion de roles

-- Crear el rol Gerente (rol sin login, usado para agrupar permisos)
CREATE ROLE Gerente;

-- Crear el usuario gerente_user con login (sin contraseña explícita)
CREATE ROLE gerente_user WITH LOGIN;

-- Asignar el rol Gerente al usuario
GRANT Gerente TO gerente_user;

-- Conceder acceso total a todas las tablas del esquema público
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO Gerente;

-- Conceder ejecución de todas las vistas (en PostgreSQL, las vistas son tablas virtuales)
GRANT SELECT ON ALL TABLES IN SCHEMA public TO Gerente;

-- Conceder ejecución de funciones y procedimientos
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO Gerente;


-- Creación de rol de Ventas

-- Crear el rol Ventas (sin login, solo para permisos)
CREATE ROLE Ventas;

-- Crear el usuario con login sin contraseña explícita
CREATE ROLE ventas_user WITH LOGIN;

-- Asignar el rol Ventas al usuario
GRANT Ventas TO ventas_user;

-- Conceder permisos de INSERT en tablas relacionadas con ventas
GRANT INSERT ON ventas, detalle_ventas, clientes TO Ventas;

-- Conceder permisos de SELECT solo si se necesita consultar antes de insertar
GRANT SELECT ON clientes TO Ventas;

-- Conceder ejecución de vistas relacionadas
GRANT SELECT ON vista_ventas_diarias, vista_clientes_activos TO Ventas;

-- Conceder ejecución de funciones relacionadas
GRANT EXECUTE ON FUNCTION registrar_venta() TO Ventas;
GRANT EXECUTE ON FUNCTION calcular_total_venta() TO Ventas;

-- Conceder ejecución de procedimientos relacionados
GRANT EXECUTE ON PROCEDURE procesar_venta TO Ventas;
GRANT EXECUTE ON PROCEDURE registrar_venta_update TO Ventas;



-- Creacion de rol de compras 

-- Crear el rol Compras (sin login, solo para permisos)
CREATE ROLE Compras;

-- Crear el usuario con login sin contraseña explícita
CREATE ROLE compras_user WITH LOGIN;

-- Asignar el rol Compras al usuario
GRANT Compras TO compras_user;

-- Conceder permisos de INSERT en tablas relacionadas con compras
GRANT INSERT ON compras, detalle_compras, proveedores TO Compras;

-- Conceder permisos de SELECT si necesita consultar antes de insertar
GRANT SELECT ON proveedores TO Compras;

-- Conceder ejecución de vistas relacionadas
GRANT SELECT ON vista_compras_mensuales, vista_proveedores_activos TO Compras;

-- Conceder ejecución de funciones relacionadas
GRANT EXECUTE ON FUNCTION registrar_compra() TO Compras;
GRANT EXECUTE ON FUNCTION calcular_total_compra() TO Compras;

-- Conceder ejecución de procedimientos relacionados (si existen)
GRANT EXECUTE ON PROCEDURE procesar_compra TO Compras;


-- Creacion de Rol de RRHH

-- Crear el rol RRHH (sin login, solo para permisos)
CREATE ROLE RRHH;

-- Crear el usuario con login sin contraseña explícita
CREATE ROLE rrhh_user WITH LOGIN;

-- Asignar el rol RRHH al usuario
GRANT RRHH TO rrhh_user;

-- Conceder permisos de lectura en todas las tablas del esquema público
GRANT SELECT ON ALL TABLES IN SCHEMA public TO RRHH;

-- Conceder permisos de lectura en todas las vistas (incluidas como tablas virtuales)
GRANT SELECT ON ALL TABLES IN SCHEMA public TO RRHH;

-- Conceder permisos de modificación (UPDATE) en todas las tablas
GRANT UPDATE ON ALL TABLES IN SCHEMA public TO RRHH;

-- No se conceden permisos de INSERT, DELETE ni EXECUTE
-- Esto garantiza que no pueda crear registros ni ejecutar funciones o procedimientos
