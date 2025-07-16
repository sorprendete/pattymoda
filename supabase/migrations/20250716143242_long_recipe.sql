-- Script para actualizar la base de datos pattymoda
-- Ejecutar en phpMyAdmin

-- 1. Agregar campos faltantes a la tabla productos
ALTER TABLE productos 
ADD COLUMN sku VARCHAR(50) UNIQUE AFTER nombre,
ADD COLUMN costo DECIMAL(10,2) DEFAULT 0 AFTER precio,
ADD COLUMN marca VARCHAR(100) AFTER descripcion,
ADD COLUMN stock_minimo INT DEFAULT 5 AFTER stock,
ADD COLUMN fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER fecha_creacion;

-- 2. Crear tabla para tallas de productos
CREATE TABLE IF NOT EXISTS producto_tallas (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    producto_id BIGINT NOT NULL,
    talla VARCHAR(10) NOT NULL,
    stock_talla INT DEFAULT 0,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
    UNIQUE KEY unique_producto_talla (producto_id, talla)
);

-- 3. Crear tabla para colores de productos
CREATE TABLE IF NOT EXISTS producto_colores (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    producto_id BIGINT NOT NULL,
    color VARCHAR(50) NOT NULL,
    codigo_hex VARCHAR(7) DEFAULT '#000000',
    stock_color INT DEFAULT 0,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE,
    UNIQUE KEY unique_producto_color (producto_id, color)
);

-- 4. Actualizar tabla clientes para separar nombres
ALTER TABLE clientes 
ADD COLUMN apellido VARCHAR(100) AFTER nombre,
ADD COLUMN distrito VARCHAR(100) AFTER direccion,
ADD COLUMN ciudad VARCHAR(100) DEFAULT 'Pampa Hermosa' AFTER distrito,
ADD COLUMN metodo_pago_preferido VARCHAR(50) DEFAULT 'EFECTIVO' AFTER ciudad,
ADD COLUMN total_compras DECIMAL(10,2) DEFAULT 0 AFTER metodo_pago_preferido,
ADD COLUMN ultima_compra TIMESTAMP NULL AFTER total_compras,
ADD COLUMN fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER fecha_creacion;

-- 5. Actualizar datos existentes de clientes (separar nombres)
UPDATE clientes SET 
    apellido = SUBSTRING_INDEX(nombre, ' ', -1),
    nombre = SUBSTRING_INDEX(nombre, ' ', 1)
WHERE apellido IS NULL;

-- 6. Actualizar tabla ventas
ALTER TABLE ventas 
ADD COLUMN subtotal DECIMAL(10,2) DEFAULT 0 AFTER precio_total,
ADD COLUMN descuento DECIMAL(10,2) DEFAULT 0 AFTER subtotal,
ADD COLUMN impuesto DECIMAL(10,2) DEFAULT 0 AFTER descuento,
ADD COLUMN notas TEXT AFTER metodo_pago,
ADD COLUMN fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER fecha;

-- 7. Actualizar tabla detalle_venta
ALTER TABLE detalle_venta 
ADD COLUMN talla VARCHAR(10) AFTER cantidad,
ADD COLUMN color VARCHAR(50) AFTER talla,
ADD COLUMN subtotal DECIMAL(10,2) GENERATED ALWAYS AS (cantidad * precio_unitario) STORED;

-- 8. Actualizar configuración de tienda
UPDATE configuracion_tienda SET 
    nombre = 'DPattyModa',
    direccion = 'Pampa Hermosa, Loreto, Perú',
    telefono = '+51 965 123 456',
    email = 'info@dpattymoda.com',
    sitio_web = 'www.dpattymoda.com',
    facebook = '@dpattymoda',
    instagram = '@dpattymoda',
    horario = 'Lun-Sab: 9:00 AM - 8:00 PM'
WHERE id = 1;

-- 9. Limpiar datos de ejemplo y agregar datos reales para DPattyModa
DELETE FROM productos;
DELETE FROM categorias;

-- Insertar categorías reales para tienda de ropa
INSERT INTO categorias (nombre, descripcion) VALUES
('Blusas', 'Blusas elegantes y casuales para toda ocasión'),
('Pantalones', 'Pantalones de vestir, casuales y jeans'),
('Vestidos', 'Vestidos elegantes para eventos especiales'),
('Faldas', 'Faldas modernas y versátiles'),
('Camisas', 'Camisas formales y casuales'),
('Shorts', 'Shorts cómodos para el día a día'),
('Chaquetas', 'Chaquetas y blazers elegantes'),
('Accesorios', 'Complementos y accesorios de moda'),
('Calzado', 'Zapatos, sandalias y zapatillas'),
('Ropa Interior', 'Lencería y ropa interior femenina');

-- Insertar productos de ejemplo para DPattyModa
INSERT INTO productos (nombre, sku, descripcion, marca, precio, costo, stock, stock_minimo, categoria_id, imagen, activo) VALUES
('Blusa Elegante Manga Larga', 'BLU001', 'Blusa elegante de manga larga, perfecta para ocasiones formales', 'DPattyModa', 85.00, 45.00, 15, 5, 1, 'https://images.pexels.com/photos/1536619/pexels-photo-1536619.jpeg', 1),
('Pantalón Casual Denim', 'PAN001', 'Pantalón casual de denim, cómodo y moderno', 'DPattyModa', 120.00, 65.00, 8, 3, 2, 'https://images.pexels.com/photos/1598505/pexels-photo-1598505.jpeg', 1),
('Vestido de Noche Elegante', 'VES001', 'Vestido elegante para eventos nocturnos', 'DPattyModa', 180.00, 95.00, 5, 2, 3, 'https://images.pexels.com/photos/1447884/pexels-photo-1447884.jpeg', 1),
('Camisa Formal Blanca', 'CAM001', 'Camisa formal blanca, ideal para oficina', 'DPattyModa', 95.00, 50.00, 12, 4, 5, 'https://images.pexels.com/photos/996329/pexels-photo-996329.jpeg', 1),
('Falda Moderna Plisada', 'FAL001', 'Falda moderna con pliegues, muy versátil', 'DPattyModa', 75.00, 40.00, 10, 3, 4, 'https://images.pexels.com/photos/1926769/pexels-photo-1926769.jpeg', 1),
('Short Casual Verano', 'SHO001', 'Short cómodo para el verano', 'DPattyModa', 55.00, 30.00, 20, 5, 6, 'https://images.pexels.com/photos/1598507/pexels-photo-1598507.jpeg', 1);

-- Insertar tallas para los productos
INSERT INTO producto_tallas (producto_id, talla, stock_talla) VALUES
(1, 'XS', 2), (1, 'S', 4), (1, 'M', 5), (1, 'L', 3), (1, 'XL', 1),
(2, 'S', 2), (2, 'M', 3), (2, 'L', 2), (2, 'XL', 1),
(3, 'XS', 1), (3, 'S', 2), (3, 'M', 1), (3, 'L', 1),
(4, 'XS', 3), (4, 'S', 4), (4, 'M', 3), (4, 'L', 2),
(5, 'S', 3), (5, 'M', 4), (5, 'L', 2), (5, 'XL', 1),
(6, 'S', 5), (6, 'M', 8), (6, 'L', 5), (6, 'XL', 2);

-- Insertar colores para los productos
INSERT INTO producto_colores (producto_id, color, codigo_hex, stock_color) VALUES
(1, 'Blanco', '#FFFFFF', 5), (1, 'Negro', '#000000', 4), (1, 'Azul', '#3B82F6', 3), (1, 'Rosa', '#EC4899', 3),
(2, 'Azul Denim', '#1E40AF', 4), (2, 'Negro', '#000000', 2), (2, 'Gris', '#6B7280', 2),
(3, 'Negro', '#000000', 2), (3, 'Rojo', '#EF4444', 2), (3, 'Azul Marino', '#1E3A8A', 1),
(4, 'Blanco', '#FFFFFF', 6), (4, 'Celeste', '#7DD3FC', 3), (4, 'Rosa Claro', '#F9A8D4', 3),
(5, 'Negro', '#000000', 4), (5, 'Gris', '#6B7280', 3), (5, 'Beige', '#D4A574', 3),
(6, 'Azul', '#3B82F6', 8), (6, 'Rosa', '#EC4899', 6), (6, 'Blanco', '#FFFFFF', 6);

-- Actualizar clientes con datos más realistas
UPDATE clientes SET 
    nombre = 'María', apellido = 'González', 
    telefono = '+51 987 654 321', 
    direccion = 'Jr. Los Tulipanes 123', 
    distrito = 'Pampa Hermosa', 
    ciudad = 'Loreto',
    total_compras = 1250.00,
    ultima_compra = '2024-01-15 10:30:00'
WHERE id = 1;

UPDATE clientes SET 
    nombre = 'Carlos', apellido = 'Ruiz',
    telefono = '+51 998 765 432',
    direccion = 'Av. Principal 456',
    distrito = 'Pampa Hermosa',
    ciudad = 'Loreto',
    total_compras = 890.50,
    ultima_compra = '2024-01-10 14:20:00'
WHERE id = 2;

UPDATE clientes SET 
    nombre = 'Ana', apellido = 'López',
    telefono = '+51 976 543 210',
    direccion = 'Calle Las Flores 789',
    distrito = 'Pampa Hermosa', 
    ciudad = 'Loreto',
    total_compras = 2100.75,
    ultima_compra = '2024-01-12 16:45:00'
WHERE id = 3;

-- Agregar más clientes
INSERT INTO clientes (nombre, apellido, email, telefono, direccion, distrito, ciudad, total_compras, ultima_compra) VALUES
('José', 'Martínez', 'jose.martinez@email.com', '+51 965 432 109', 'Jr. Comercio 321', 'Pampa Hermosa', 'Loreto', 567.25, '2024-01-08 11:15:00'),
('Rosa', 'Vásquez', 'rosa.vasquez@email.com', '+51 954 321 098', 'Av. Los Cedros 654', 'Pampa Hermosa', 'Loreto', 1450.00, '2024-01-14 09:30:00'),
('Luis', 'Torres', 'luis.torres@email.com', '+51 943 210 987', 'Calle San Martín 987', 'Pampa Hermosa', 'Loreto', 780.50, '2024-01-11 15:20:00');

-- Actualizar usuario admin
UPDATE usuarios SET 
    nombre = 'Admin DPattyModa',
    email = 'admin@dpattymoda.com'
WHERE id = 1;

UPDATE usuarios SET 
    nombre = 'Vendedor DPattyModa',
    email = 'vendedor@dpattymoda.com'
WHERE id = 2;

-- Crear índices adicionales para mejor rendimiento
CREATE INDEX idx_productos_sku ON productos(sku);
CREATE INDEX idx_productos_marca ON productos(marca);
CREATE INDEX idx_clientes_apellido ON clientes(apellido);
CREATE INDEX idx_ventas_estado ON ventas(estado);
CREATE INDEX idx_ventas_metodo_pago ON ventas(metodo_pago);