-- Selección de la base de datos para trabajar
USE Cuchuflito_SA;

--- Funciones del sistema

--- calcular_total_compra

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

--- calcular_total_venta

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

--- stock_actual_producto

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

--- total_facturado_cliente

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


-- Calcular el total de una compra específica (por ID)  
SELECT calcular_total_compra(x); -- Devuelve el total de la compra con ID x

-- Calcular el total de una venta específica (por ID)
SELECT calcular_total_venta(x); -- Devuelve el total de la venta con ID x

-- Consultar el stock actual de un producto (por ID)
SELECT stock_actual_producto(x); -- Devuelve el stock actual del producto con ID x

-- Calcular el total facturado a un cliente (por ID)
SELECT total_facturado_cliente(x); -- Devuelve el total facturado al cliente con ID x7
