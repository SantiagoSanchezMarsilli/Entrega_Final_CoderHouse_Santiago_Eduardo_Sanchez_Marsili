-- Selección de la base de datos para trabajar
USE Cuchuflito_SA;

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