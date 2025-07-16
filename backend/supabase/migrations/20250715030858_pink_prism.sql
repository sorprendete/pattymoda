-- Script SQL para crear la base de datos tienda_db
-- Importar este archivo en phpMyAdmin

-- Crear base de datos
CREATE DATABASE IF NOT EXISTS tienda_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE tienda_db;

-- Tabla de usuarios
CREATE TABLE usuarios (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    rol ENUM('ADMIN', 'VENDEDOR') NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE
);

-- Tabla de categorías
CREATE TABLE categorias (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT
);

-- Tabla de productos
CREATE TABLE productos (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL,
    imagen VARCHAR(255),
    categoria_id BIGINT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE CASCADE
);

-- Tabla de clientes
CREATE TABLE clientes (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    direccion VARCHAR(255),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE
);

-- Tabla de ventas
CREATE TABLE ventas (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    cliente_id BIGINT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    precio_total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE
);

-- Tabla de detalle de ventas
CREATE TABLE detalle_venta (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    venta_id BIGINT NOT NULL,
    producto_id BIGINT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (venta_id) REFERENCES ventas(id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE
);

-- Tabla de configuración de la tienda
CREATE TABLE configuracion_tienda (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(255),
    logo VARCHAR(255),
    telefono VARCHAR(20),
    email VARCHAR(100),
    sitio_web VARCHAR(100)
);

-- Índices para mejorar el rendimiento
CREATE INDEX idx_productos_categoria ON productos(categoria_id);
CREATE INDEX idx_productos_nombre ON productos(nombre);
CREATE INDEX idx_productos_activo ON productos(activo);
CREATE INDEX idx_clientes_nombre ON clientes(nombre);
CREATE INDEX idx_clientes_activo ON clientes(activo);
CREATE INDEX idx_ventas_cliente ON ventas(cliente_id);
CREATE INDEX idx_ventas_fecha ON ventas(fecha);
CREATE INDEX idx_detalle_venta_venta ON detalle_venta(venta_id);
CREATE INDEX idx_detalle_venta_producto ON detalle_venta(producto_id);

-- Datos iniciales
INSERT INTO usuarios (nombre, email, password, rol) VALUES 
('Administrador', 'admin@tienda.com', '$2a$10$X5wFWtAFrpxoJf1sVtNYqeqOkNxKjCmG8m7VBwLQCzKqGlOPOqEHS', 'ADMIN'),
('Vendedor', 'vendedor@tienda.com', '$2a$10$X5wFWtAFrpxoJf1sVtNYqeqOkNxKjCmG8m7VBwLQCzKqGlOPOqEHS', 'VENDEDOR');

INSERT INTO categorias (nombre, descripcion) VALUES 
('Electrónicos', 'Productos electrónicos y tecnología'),
('Ropa', 'Vestimenta y accesorios'),
('Hogar', 'Artículos para el hogar'),
('Deportes', 'Artículos deportivos y fitness');

INSERT INTO productos (nombre, descripcion, precio, stock, categoria_id) VALUES 
('Smartphone Samsung', 'Teléfono inteligente Samsung Galaxy', 699.99, 25, 1),
('Laptop Dell', 'Laptop Dell Inspiron 15', 899.99, 15, 1),
('Camiseta Nike', 'Camiseta deportiva Nike', 29.99, 100, 2),
('Pantalón Jeans', 'Pantalón de mezclilla', 49.99, 80, 2),
('Cafetera', 'Cafetera automática', 129.99, 30, 3),
('Balón de Fútbol', 'Balón oficial de fútbol', 39.99, 50, 4);

INSERT INTO clientes (nombre, email, telefono, direccion) VALUES 
('Juan Pérez', 'juan.perez@email.com', '123-456-7890', 'Calle 123, Ciudad'),
('María García', 'maria.garcia@email.com', '098-765-4321', 'Avenida 456, Ciudad'),
('Carlos López', 'carlos.lopez@email.com', '555-123-4567', 'Plaza 789, Ciudad');

INSERT INTO configuracion_tienda (nombre, direccion, telefono, email, sitio_web) VALUES 
('Mi Tienda', 'Calle Principal 123, Ciudad', '123-456-7890', 'info@mitienda.com', 'www.mitienda.com');

-- Crear usuario para la aplicación (opcional)
-- CREATE USER 'tienda_user'@'localhost' IDENTIFIED BY 'password123';
-- GRANT ALL PRIVILEGES ON tienda_db.* TO 'tienda_user'@'localhost';
-- FLUSH PRIVILEGES;