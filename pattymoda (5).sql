-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 16-07-2025 a las 23:07:15
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `pattymoda`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `id` bigint(20) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`id`, `nombre`, `descripcion`) VALUES
(1, 'Blusas', 'Blusas elegantes y casuales para toda ocasión'),
(2, 'Pantalones', 'Pantalones de vestir, casuales y jeans'),
(3, 'Vestidos', 'Vestidos elegantes para eventos especiales'),
(4, 'Faldas', 'Faldas modernas y versátiles'),
(5, 'Camisas', 'Camisas formales y casuales'),
(6, 'Shorts', 'Shorts cómodos para el día a día'),
(7, 'Chaquetas', 'Chaquetas y blazers elegantes'),
(8, 'Accesorios', 'Complementos y accesorios de moda'),
(9, 'Calzado', 'Zapatos, sandalias y zapatillas'),
(10, 'Ropa Interior', 'Lencería y ropa interior femenina');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id` bigint(20) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `distrito` varchar(100) DEFAULT NULL,
  `ciudad` varchar(100) NOT NULL DEFAULT 'Pampa Hermosa',
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `total_compras` decimal(10,2) DEFAULT 0.00,
  `ultima_compra` timestamp NULL DEFAULT NULL,
  `metodo_pago_preferido` varchar(50) DEFAULT 'EFECTIVO',
  `activo` tinyint(1) DEFAULT 1,
  `notas` text DEFAULT NULL,
  `creado_por` bigint(20) DEFAULT NULL,
  `modificado_por` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id`, `nombre`, `apellido`, `email`, `telefono`, `direccion`, `distrito`, `ciudad`, `fecha_creacion`, `fecha_actualizacion`, `total_compras`, `ultima_compra`, `metodo_pago_preferido`, `activo`, `notas`, `creado_por`, `modificado_por`) VALUES
(1, 'María', 'González', 'juan.perez@email.com', '+51 987 654 321', 'Jr. Los Tulipanes 123', 'Pampa Hermosa', 'Loreto', '2025-07-16 16:32:42', '2025-07-16 16:32:42', 1250.00, '2024-01-15 15:30:00', 'EFECTIVO', 1, NULL, NULL, NULL),
(2, 'Carlos', 'Ruiz', 'maria.garcia@email.com', '+51 998 765 432', 'Av. Principal 456', 'Pampa Hermosa', 'Loreto', '2025-07-16 16:32:42', '2025-07-16 16:32:42', 890.50, '2024-01-10 19:20:00', 'EFECTIVO', 1, NULL, NULL, NULL),
(3, 'Ana', 'López', 'carlos.lopez@email.com', '+51 976 543 210', 'Calle Las Flores 789', 'Pampa Hermosa', 'Loreto', '2025-07-16 16:32:42', '2025-07-16 16:32:42', 2100.75, '2024-01-12 21:45:00', 'EFECTIVO', 1, NULL, NULL, NULL),
(4, 'José', 'Martínez', 'jose.martínez@email.com', '+51 965 432 109', 'Jr. Comercio 321', 'Pampa Hermosa', 'Loreto', '2025-07-16 16:32:42', '2025-07-16 16:32:42', 567.25, '2024-01-08 16:15:00', 'EFECTIVO', 1, NULL, NULL, NULL),
(5, 'Rosa', 'Vásquez', 'rosa.vásquez@email.com', '+51 954 321 098', 'Av. Los Cedros 654', 'Pampa Hermosa', 'Loreto', '2025-07-16 16:32:42', '2025-07-16 16:32:42', 1450.00, '2024-01-14 14:30:00', 'EFECTIVO', 1, NULL, NULL, NULL),
(6, 'Luis', 'Torres', 'luis.torres@email.com', '+51 943 210 987', 'Calle San Martín 987', 'Pampa Hermosa', 'Loreto', '2025-07-16 16:32:42', '2025-07-16 16:32:42', 780.50, '2024-01-11 20:20:00', 'EFECTIVO', 1, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `configuracion_tienda`
--

CREATE TABLE `configuracion_tienda` (
  `id` bigint(20) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `sitio_web` varchar(100) DEFAULT NULL,
  `facebook` varchar(100) DEFAULT NULL,
  `instagram` varchar(100) DEFAULT NULL,
  `horario` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `configuracion_tienda`
--

INSERT INTO `configuracion_tienda` (`id`, `nombre`, `direccion`, `logo`, `telefono`, `email`, `sitio_web`, `facebook`, `instagram`, `horario`) VALUES
(1, 'DPattyModa', 'Pampa Hermosa, Loreto, Perú', NULL, '+51 965 123 456', 'info@dpattymoda.com', 'www.dpattymoda.com', '@dpattymoda', '@dpattymoda', 'Lun-Sab: 9:00 AM - 8:00 PM');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_venta`
--

CREATE TABLE `detalle_venta` (
  `id` bigint(20) NOT NULL,
  `venta_id` bigint(20) NOT NULL,
  `producto_id` bigint(20) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `talla` varchar(10) DEFAULT NULL,
  `color` varchar(50) DEFAULT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) GENERATED ALWAYS AS (`cantidad` * `precio_unitario`) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `id` bigint(20) NOT NULL,
  `usuario_id` bigint(20) NOT NULL,
  `token` varchar(255) NOT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_expiracion` timestamp NOT NULL DEFAULT current_timestamp(),
  `usado` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `password_reset_tokens`
--

INSERT INTO `password_reset_tokens` (`id`, `usuario_id`, `token`, `fecha_creacion`, `fecha_expiracion`, `usado`) VALUES
(1, 3, '0b835c99-3ec1-46fe-890e-96f579e95f45', '2025-07-16 16:41:29', '2025-07-16 17:41:29', 1),
(2, 1, '213cf288-1e97-464d-b6e2-330d508c204e', '2025-07-16 16:45:14', '2025-07-16 17:45:14', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id` bigint(20) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `sku` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `marca` varchar(100) DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL,
  `costo` decimal(10,2) NOT NULL DEFAULT 0.00,
  `stock` int(11) NOT NULL,
  `stock_minimo` int(11) NOT NULL DEFAULT 5,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `imagen` varchar(255) DEFAULT NULL,
  `categoria_id` bigint(20) NOT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `creado_por` bigint(20) DEFAULT NULL,
  `modificado_por` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id`, `nombre`, `sku`, `descripcion`, `marca`, `precio`, `costo`, `stock`, `stock_minimo`, `fecha_creacion`, `fecha_actualizacion`, `imagen`, `categoria_id`, `activo`, `creado_por`, `modificado_por`) VALUES
(1, 'Blusa Elegante Manga Larga', 'BLU001', 'Blusa elegante de manga larga, perfecta para ocasiones formales', 'DPattyModa', 85.00, 45.00, 15, 5, '2025-07-16 16:32:42', '2025-07-16 16:32:42', 'https://images.pexels.com/photos/1536619/pexels-photo-1536619.jpeg', 1, 1, NULL, NULL),
(2, 'Pantalón Casual Denim', 'PAN001', 'Pantalón casual de denim, cómodo y moderno', 'DPattyModa', 120.00, 65.00, 8, 3, '2025-07-16 16:32:42', '2025-07-16 16:32:42', 'https://images.pexels.com/photos/1598505/pexels-photo-1598505.jpeg', 2, 1, NULL, NULL),
(3, 'Vestido de Noche Elegante', 'VES001', 'Vestido elegante para eventos nocturnos', 'DPattyModa', 180.00, 95.00, 5, 2, '2025-07-16 16:32:42', '2025-07-16 16:32:42', 'https://images.pexels.com/photos/1447884/pexels-photo-1447884.jpeg', 3, 1, NULL, NULL),
(4, 'Camisa Formal Blanca', 'CAM001', 'Camisa formal blanca, ideal para oficina', 'DPattyModa', 95.00, 50.00, 12, 4, '2025-07-16 16:32:42', '2025-07-16 16:32:42', 'https://images.pexels.com/photos/996329/pexels-photo-996329.jpeg', 5, 1, NULL, NULL),
(5, 'Falda Moderna Plisada', 'FAL001', 'Falda moderna con pliegues, muy versátil', 'DPattyModa', 75.00, 40.00, 10, 3, '2025-07-16 16:32:42', '2025-07-16 16:32:42', 'https://images.pexels.com/photos/1926769/pexels-photo-1926769.jpeg', 4, 1, NULL, NULL),
(6, 'Short Casual Verano', 'SHO001', 'Short cómodo para el verano', 'DPattyModa', 55.00, 30.00, 20, 5, '2025-07-16 16:32:42', '2025-07-16 19:34:02', 'https://images.pexels.com/photos/1598507/pexels-photo-1598507.jpeg', 6, 0, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto_colores`
--

CREATE TABLE `producto_colores` (
  `id` bigint(20) NOT NULL,
  `producto_id` bigint(20) NOT NULL,
  `color` varchar(50) NOT NULL,
  `codigo_hex` varchar(7) DEFAULT '#000000',
  `stock_color` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `producto_colores`
--

INSERT INTO `producto_colores` (`id`, `producto_id`, `color`, `codigo_hex`, `stock_color`) VALUES
(1, 1, 'Blanco', '#FFFFFF', 5),
(2, 1, 'Negro', '#000000', 4),
(3, 1, 'Azul', '#3B82F6', 3),
(4, 1, 'Rosa', '#EC4899', 3),
(5, 2, 'Azul Denim', '#1E40AF', 4),
(6, 2, 'Negro', '#000000', 2),
(7, 2, 'Gris', '#6B7280', 2),
(8, 3, 'Negro', '#000000', 2),
(9, 3, 'Rojo', '#EF4444', 2),
(10, 3, 'Azul Marino', '#1E3A8A', 1),
(11, 4, 'Blanco', '#FFFFFF', 6),
(12, 4, 'Celeste', '#7DD3FC', 3),
(13, 4, 'Rosa Claro', '#F9A8D4', 3),
(14, 5, 'Negro', '#000000', 4),
(15, 5, 'Gris', '#6B7280', 3),
(16, 5, 'Beige', '#D4A574', 3),
(17, 6, 'Azul', '#3B82F6', 8),
(18, 6, 'Rosa', '#EC4899', 6),
(19, 6, 'Blanco', '#FFFFFF', 6);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto_descuentos`
--

CREATE TABLE `producto_descuentos` (
  `id` bigint(20) NOT NULL,
  `producto_id` bigint(20) NOT NULL,
  `porcentaje_descuento` decimal(5,2) NOT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto_imagenes`
--

CREATE TABLE `producto_imagenes` (
  `id` bigint(20) NOT NULL,
  `producto_id` bigint(20) NOT NULL,
  `url_imagen` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto_tallas`
--

CREATE TABLE `producto_tallas` (
  `id` bigint(20) NOT NULL,
  `producto_id` bigint(20) NOT NULL,
  `talla` varchar(10) NOT NULL,
  `stock_talla` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `producto_tallas`
--

INSERT INTO `producto_tallas` (`id`, `producto_id`, `talla`, `stock_talla`) VALUES
(1, 1, 'XS', 2),
(2, 1, 'S', 4),
(3, 1, 'M', 5),
(4, 1, 'L', 3),
(5, 1, 'XL', 1),
(6, 2, 'S', 2),
(7, 2, 'M', 3),
(8, 2, 'L', 2),
(9, 2, 'XL', 1),
(10, 3, 'XS', 1),
(11, 3, 'S', 2),
(12, 3, 'M', 1),
(13, 3, 'L', 1),
(14, 4, 'XS', 3),
(15, 4, 'S', 4),
(16, 4, 'M', 3),
(17, 4, 'L', 2),
(18, 5, 'S', 3),
(19, 5, 'M', 4),
(20, 5, 'L', 2),
(21, 5, 'XL', 1),
(22, 6, 'S', 5),
(23, 6, 'M', 8),
(24, 6, 'L', 5),
(25, 6, 'XL', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` bigint(20) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `rol` enum('ADMIN','VENDEDOR') NOT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `activo` tinyint(1) DEFAULT 1,
  `foto_perfil` varchar(255) DEFAULT NULL,
  `intentos_recuperacion` int(11) DEFAULT 0,
  `ultimo_intento_recuperacion` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `nombre`, `email`, `password`, `rol`, `fecha_creacion`, `activo`, `foto_perfil`, `intentos_recuperacion`, `ultimo_intento_recuperacion`) VALUES
(1, 'Admin DPattyModa', 'admin@dpattymoda.com', '$2a$10$vG7SV3wo9mS8iGNCwvThrufIYCOloXFaPyV0YAmPF62WQGZosYJz2', 'ADMIN', '2025-07-16 16:32:42', 1, NULL, 0, NULL),
(2, 'Vendedor DPattyModa', 'vendedor@dpattymoda.com', '$2a$10$X5wFWtAFrpxoJf1sVtNYqeqOkNxKjCmG8m7VBwLQCzKqGlOPOqEHS', 'VENDEDOR', '2025-07-16 16:32:42', 1, NULL, 0, NULL),
(3, 'Super Admin DPattyModa', 'superadmin@dpattymoda.com', '$2a$10$TYDH6Yr7Ju1LP1jN3n4WNOxqjz4AnuUeA8rbUdp/7DFEHe4r1d0kC', 'ADMIN', '2025-07-16 16:32:42', 1, NULL, 0, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE `ventas` (
  `id` bigint(20) NOT NULL,
  `cliente_id` bigint(20) NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp(),
  `subtotal` decimal(10,2) NOT NULL DEFAULT 0.00,
  `descuento` decimal(10,2) NOT NULL DEFAULT 0.00,
  `impuesto` decimal(10,2) NOT NULL DEFAULT 0.00,
  `precio_total` decimal(10,2) NOT NULL,
  `estado` enum('PENDIENTE','PAGADA','ANULADA') NOT NULL DEFAULT 'PENDIENTE',
  `metodo_pago` varchar(50) DEFAULT NULL,
  `notas` text DEFAULT NULL,
  `creado_por` bigint(20) DEFAULT NULL,
  `modificado_por` bigint(20) DEFAULT NULL,
  `fecha_actualizacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_clientes_nombre` (`nombre`),
  ADD KEY `idx_clientes_apellido` (`apellido`),
  ADD KEY `idx_clientes_activo` (`activo`),
  ADD KEY `idx_clientes_creado_por` (`creado_por`),
  ADD KEY `idx_clientes_modificado_por` (`modificado_por`);

--
-- Indices de la tabla `configuracion_tienda`
--
ALTER TABLE `configuracion_tienda`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `detalle_venta`
--
ALTER TABLE `detalle_venta`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_detalle_venta_venta` (`venta_id`),
  ADD KEY `idx_detalle_venta_producto` (`producto_id`);

--
-- Indices de la tabla `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `token` (`token`),
  ADD KEY `idx_token` (`token`),
  ADD KEY `idx_usuario_id` (`usuario_id`),
  ADD KEY `idx_fecha_expiracion` (`fecha_expiracion`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sku` (`sku`),
  ADD KEY `idx_productos_categoria` (`categoria_id`),
  ADD KEY `idx_productos_nombre` (`nombre`),
  ADD KEY `idx_productos_activo` (`activo`),
  ADD KEY `idx_productos_marca` (`marca`),
  ADD KEY `idx_productos_sku` (`sku`),
  ADD KEY `idx_productos_creado_por` (`creado_por`),
  ADD KEY `idx_productos_modificado_por` (`modificado_por`);

--
-- Indices de la tabla `producto_colores`
--
ALTER TABLE `producto_colores`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_producto_color` (`producto_id`,`color`),
  ADD KEY `idx_producto_colores_producto` (`producto_id`);

--
-- Indices de la tabla `producto_descuentos`
--
ALTER TABLE `producto_descuentos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_producto_descuentos_producto` (`producto_id`);

--
-- Indices de la tabla `producto_imagenes`
--
ALTER TABLE `producto_imagenes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_producto_imagenes_producto` (`producto_id`);

--
-- Indices de la tabla `producto_tallas`
--
ALTER TABLE `producto_tallas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_producto_talla` (`producto_id`,`talla`),
  ADD KEY `idx_producto_tallas_producto` (`producto_id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indices de la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_ventas_cliente` (`cliente_id`),
  ADD KEY `idx_ventas_estado` (`estado`),
  ADD KEY `idx_ventas_metodo_pago` (`metodo_pago`),
  ADD KEY `idx_ventas_creado_por` (`creado_por`),
  ADD KEY `idx_ventas_modificado_por` (`modificado_por`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `configuracion_tienda`
--
ALTER TABLE `configuracion_tienda`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `detalle_venta`
--
ALTER TABLE `detalle_venta`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `producto_colores`
--
ALTER TABLE `producto_colores`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de la tabla `producto_descuentos`
--
ALTER TABLE `producto_descuentos`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `producto_imagenes`
--
ALTER TABLE `producto_imagenes`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `producto_tallas`
--
ALTER TABLE `producto_tallas`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD CONSTRAINT `clientes_ibfk_1` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `clientes_ibfk_2` FOREIGN KEY (`modificado_por`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `detalle_venta`
--
ALTER TABLE `detalle_venta`
  ADD CONSTRAINT `detalle_venta_ibfk_1` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `detalle_venta_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD CONSTRAINT `password_reset_tokens_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `productos_ibfk_1` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `productos_ibfk_2` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `productos_ibfk_3` FOREIGN KEY (`modificado_por`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `producto_colores`
--
ALTER TABLE `producto_colores`
  ADD CONSTRAINT `producto_colores_ibfk_1` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `producto_descuentos`
--
ALTER TABLE `producto_descuentos`
  ADD CONSTRAINT `producto_descuentos_ibfk_1` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `producto_imagenes`
--
ALTER TABLE `producto_imagenes`
  ADD CONSTRAINT `producto_imagenes_ibfk_1` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `producto_tallas`
--
ALTER TABLE `producto_tallas`
  ADD CONSTRAINT `producto_tallas_ibfk_1` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD CONSTRAINT `ventas_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ventas_ibfk_2` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `ventas_ibfk_3` FOREIGN KEY (`modificado_por`) REFERENCES `usuarios` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
