-- Selección de la base de datos para trabajar
USE Cuchuflito_SA;

--- Stored Procedures

--- Procedimiento registrar_compra

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

--- Procedimiento registrar_venta

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

--- Procedimiento actualizar_stock

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

--- Procedimiento registrar_cuota

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

--- Procedimiento ObtenerResumenComprasPorEmpleado

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

--- Procedimiento ObtenerResumenVentasPorEmpleado

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

--- Procedimiento registrar_venta_update

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

-- Registrar una compra
CALL registrar_compra(3, '2025-09-14', 15000.00, 1); -- Inserta una nueva compra en la tabla compras
-- proveedor_id, fecha_compra, total_compra, comprador_id

-- Registrar una venta
CALL registrar_venta(7, 2, 2, 12, 3, 499.99); -- Registra una venta y su detalle en ventas y ventas_productos, sin validar stock
-- cliente_id, medio_pago_id, vendedor_id, producto_id, cantidad, precio_unitario

-- Actualizar el stock de un producto (sumar cantidad)
CALL actualizar_stock(12, 50); -- Suma la cantidad indicada al stock actual del producto especificado.
-- producto_id, cantidad

-- Registrar una cuota de pago
CALL registrar_cuota(2, 6); 
-- medio_id, cantidad_cuotas

-- Obtener resumen de compras por empleado
CALL ObtenerResumenComprasPorEmpleado(); -- Devuelve una tabla con nombre del empleado, cantidad de compras, monto total y promedio.
-- No requiere parámetros

-- Obtener resumen de ventas por empleado
CALL ObtenerResumenVentasPorEmpleado(); -- Devuelve una tabla con nombre del empleado, cantidad de ventas, monto total y promedio.
-- No requiere parámetros

-- Registrar una venta con control de stock
CALL registrar_venta_update(7, 2, 1, 12, 3, 499.99); -- Registra una venta solo si hay stock suficiente, actualiza inventario y guarda el detalle.
-- cliente_id, medio_pago_id, vendedor_id, producto_id, cantidad, precio_unitario
