-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 17-07-2025 a las 18:49:38
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

DELIMITER $$
--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `obtener_impuesto_por_defecto` () RETURNS DECIMAL(5,2) DETERMINISTIC READS SQL DATA BEGIN
    DECLARE pct DECIMAL(5,2) DEFAULT 0.00;
    SELECT porcentaje INTO pct
      FROM `configuracion_impuestos`
      WHERE activo=TRUE AND aplicar_por_defecto=TRUE
      LIMIT 1;
    RETURN COALESCE(pct,0.00);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `id` bigint(20) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comprobantes`
--

CREATE TABLE `comprobantes` (
  `id` bigint(20) NOT NULL,
  `venta_id` bigint(20) NOT NULL,
  `tipo` enum('BOLETA','FACTURA') NOT NULL,
  `serie` varchar(10) NOT NULL,
  `numero` varchar(20) NOT NULL,
  `fecha_emision` timestamp NOT NULL DEFAULT current_timestamp(),
  `subtotal` decimal(10,2) NOT NULL,
  `igv` decimal(10,2) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `qr_code` text DEFAULT NULL,
  `estado` enum('EMITIDA','ANULADA') DEFAULT 'EMITIDA',
  `hash_validation` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `configuracion_impuestos`
--

CREATE TABLE `configuracion_impuestos` (
  `id` bigint(20) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `porcentaje` decimal(5,2) NOT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `aplicar_por_defecto` tinyint(1) DEFAULT 0,
  `descripcion` varchar(200) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `configuracion_impuestos`
--

INSERT INTO `configuracion_impuestos` (`id`, `nombre`, `porcentaje`, `activo`, `aplicar_por_defecto`, `descripcion`, `created_at`, `updated_at`) VALUES
(1, 'IGV', 0.00, 0, 1, 'Impuesto General a las Ventas - Configurado para región de la selva (exonerado)', '2025-07-16 22:28:41', '2025-07-16 22:28:41'),
(2, 'IGV_ESTANDAR', 18.00, 0, 0, 'IGV estándar del 18% para otras regiones del Perú', '2025-07-16 22:28:41', '2025-07-16 22:28:41'),
(3, 'ISC', 0.00, 0, 0, 'Impuesto Selectivo al Consumo', '2025-07-16 22:28:41', '2025-07-16 22:28:41'),
(4, 'IMPUESTO_MUNICIPAL', 0.00, 0, 0, 'Impuesto Municipal Local', '2025-07-16 22:28:41', '2025-07-16 22:28:41'),
(5, 'IGV_SELVA', 0.00, 1, 1, 'IGV para región de la selva - Exonerado', '2025-07-16 22:28:41', '2025-07-16 22:28:41'),
(6, 'IGV_COSTA_SIERRA', 18.00, 0, 0, 'IGV para costa y sierra del Perú', '2025-07-16 22:28:41', '2025-07-16 22:28:41');

--
-- Disparadores `configuracion_impuestos`
--
DELIMITER $$
CREATE TRIGGER `after_update_impuestos` AFTER UPDATE ON `configuracion_impuestos` FOR EACH ROW BEGIN
    IF OLD.porcentaje <> NEW.porcentaje THEN
        INSERT INTO `historial_impuestos`
          (`impuesto_id`,`accion`,`porcentaje_anterior`,`porcentaje_nuevo`,`observaciones`)
        VALUES
          (NEW.id,'MODIFICADO',OLD.porcentaje,NEW.porcentaje,
           CONCAT('Porcentaje cambiado de ',OLD.porcentaje,'% a ',NEW.porcentaje,'%'));
    END IF;
    IF OLD.activo <> NEW.activo THEN
        INSERT INTO `historial_impuestos`
          (`impuesto_id`,`accion`,`observaciones`)
        VALUES
          (NEW.id,
           IF(NEW.activo,'ACTIVADO','DESACTIVADO'),
           CONCAT('Impuesto ',IF(NEW.activo,'activado','desactivado')));
    END IF;
END
$$
DELIMITER ;

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
-- Estructura de tabla para la tabla `historial_impuestos`
--

CREATE TABLE `historial_impuestos` (
  `id` bigint(20) NOT NULL,
  `impuesto_id` bigint(20) NOT NULL,
  `accion` enum('CREADO','MODIFICADO','ACTIVADO','DESACTIVADO') NOT NULL,
  `porcentaje_anterior` decimal(5,2) DEFAULT NULL,
  `porcentaje_nuevo` decimal(5,2) DEFAULT NULL,
  `usuario_id` bigint(20) DEFAULT NULL,
  `fecha_cambio` timestamp NOT NULL DEFAULT current_timestamp(),
  `observaciones` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `metodos_pago_venta`
--

CREATE TABLE `metodos_pago_venta` (
  `id` bigint(20) NOT NULL,
  `venta_id` bigint(20) NOT NULL,
  `tipo_pago` enum('EFECTIVO','TARJETA','YAPE','PLIN','TRANSFERENCIA') NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `referencia` varchar(100) DEFAULT NULL,
  `tipo_tarjeta` varchar(50) DEFAULT NULL,
  `ultimos_4_digitos` varchar(4) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
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
(1, 1, '73b2a707-11e9-4831-a425-c8acc025a0cc', '2025-07-16 22:34:49', '2025-07-16 23:34:49', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id` bigint(20) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `sku` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `marca` varchar(100) DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL,
  `costo` decimal(10,2) DEFAULT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  `stock_minimo` int(11) DEFAULT 0,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `imagen` varchar(255) DEFAULT NULL,
  `categoria_id` bigint(20) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `creado_por` bigint(20) DEFAULT NULL,
  `modificado_por` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `secuencias_comprobantes`
--

CREATE TABLE `secuencias_comprobantes` (
  `id` bigint(20) NOT NULL,
  `tipo` enum('BOLETA','FACTURA') NOT NULL,
  `serie` varchar(10) NOT NULL,
  `ultimo_numero` int(11) NOT NULL DEFAULT 0,
  `activo` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` bigint(20) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `rol` enum('SUPER_ADMIN','ADMIN','MANAGER','VENDEDOR','CAJERO','INVENTARIO') NOT NULL,
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
(1, 'Super Administrador', 'superadmin@gmail.com', '$2a$10$UVF7iyQYdCWkqzXHFm77EOxpNwmUg1VqISzollJhWg8jlpVUD.Huu', 'SUPER_ADMIN', '2025-07-16 22:34:14', 1, NULL, 0, NULL);

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
  `fecha_actualizacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `numero_venta` varchar(20) DEFAULT NULL,
  `tipo_comprobante` enum('BOLETA','FACTURA') DEFAULT 'BOLETA',
  `ruc_cliente` varchar(11) DEFAULT NULL,
  `razon_social` varchar(200) DEFAULT NULL,
  `impuesto_aplicado` varchar(50) DEFAULT NULL,
  `porcentaje_impuesto` decimal(5,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Disparadores `ventas`
--
DELIMITER $$
CREATE TRIGGER `before_insert_venta` BEFORE INSERT ON `ventas` FOR EACH ROW BEGIN
    IF NEW.numero_venta IS NULL THEN
        SET NEW.numero_venta = CONCAT('V', LPAD(
             COALESCE(
               (SELECT MAX(CAST(SUBSTRING(numero_venta,2) AS UNSIGNED))
                FROM ventas WHERE numero_venta LIKE 'V%'),0
             )+1,8,'0'));
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_impuestos_activos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_impuestos_activos` (
`id` bigint(20)
,`nombre` varchar(50)
,`porcentaje` decimal(5,2)
,`activo` tinyint(1)
,`aplicar_por_defecto` tinyint(1)
,`descripcion` varchar(200)
,`created_at` timestamp
,`updated_at` timestamp
,`estado_display` varchar(18)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_impuestos_activos`
--
DROP TABLE IF EXISTS `vista_impuestos_activos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_impuestos_activos`  AS SELECT `configuracion_impuestos`.`id` AS `id`, `configuracion_impuestos`.`nombre` AS `nombre`, `configuracion_impuestos`.`porcentaje` AS `porcentaje`, `configuracion_impuestos`.`activo` AS `activo`, `configuracion_impuestos`.`aplicar_por_defecto` AS `aplicar_por_defecto`, `configuracion_impuestos`.`descripcion` AS `descripcion`, `configuracion_impuestos`.`created_at` AS `created_at`, `configuracion_impuestos`.`updated_at` AS `updated_at`, CASE WHEN `configuracion_impuestos`.`activo` <> 0 AND `configuracion_impuestos`.`aplicar_por_defecto` <> 0 THEN 'ACTIVO_POR_DEFECTO' WHEN `configuracion_impuestos`.`activo` THEN 'ACTIVO' ELSE 'INACTIVO' END AS `estado_display` FROM `configuracion_impuestos` ORDER BY `configuracion_impuestos`.`aplicar_por_defecto` DESC, `configuracion_impuestos`.`activo` DESC, `configuracion_impuestos`.`nombre` ASC ;

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
  ADD UNIQUE KEY `email` (`email`);

--
-- Indices de la tabla `comprobantes`
--
ALTER TABLE `comprobantes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `comprobantes_ibfk_1` (`venta_id`);

--
-- Indices de la tabla `configuracion_impuestos`
--
ALTER TABLE `configuracion_impuestos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_impuestos_activo` (`activo`),
  ADD KEY `idx_impuestos_por_defecto` (`aplicar_por_defecto`),
  ADD KEY `idx_impuestos_nombre` (`nombre`);

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
  ADD KEY `detalle_venta_ibfk_1` (`venta_id`),
  ADD KEY `detalle_venta_ibfk_2` (`producto_id`);

--
-- Indices de la tabla `historial_impuestos`
--
ALTER TABLE `historial_impuestos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `impuesto_id` (`impuesto_id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `metodos_pago_venta`
--
ALTER TABLE `metodos_pago_venta`
  ADD PRIMARY KEY (`id`),
  ADD KEY `metodos_pago_venta_ibfk_1` (`venta_id`);

--
-- Indices de la tabla `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `password_reset_tokens_ibfk_1` (`usuario_id`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_producto_categoria` (`categoria_id`);

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
-- Indices de la tabla `secuencias_comprobantes`
--
ALTER TABLE `secuencias_comprobantes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_serie` (`tipo`,`serie`);

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
  ADD UNIQUE KEY `numero_venta` (`numero_venta`),
  ADD KEY `idx_ventas_cliente` (`cliente_id`),
  ADD KEY `idx_ventas_estado` (`estado`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `comprobantes`
--
ALTER TABLE `comprobantes`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `configuracion_impuestos`
--
ALTER TABLE `configuracion_impuestos`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `configuracion_tienda`
--
ALTER TABLE `configuracion_tienda`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detalle_venta`
--
ALTER TABLE `detalle_venta`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `historial_impuestos`
--
ALTER TABLE `historial_impuestos`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `metodos_pago_venta`
--
ALTER TABLE `metodos_pago_venta`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `producto_colores`
--
ALTER TABLE `producto_colores`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

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
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `secuencias_comprobantes`
--
ALTER TABLE `secuencias_comprobantes`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `comprobantes`
--
ALTER TABLE `comprobantes`
  ADD CONSTRAINT `comprobantes_ibfk_1` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `detalle_venta`
--
ALTER TABLE `detalle_venta`
  ADD CONSTRAINT `detalle_venta_ibfk_1` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `detalle_venta_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `historial_impuestos`
--
ALTER TABLE `historial_impuestos`
  ADD CONSTRAINT `historial_impuestos_ibfk_1` FOREIGN KEY (`impuesto_id`) REFERENCES `configuracion_impuestos` (`id`),
  ADD CONSTRAINT `historial_impuestos_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `metodos_pago_venta`
--
ALTER TABLE `metodos_pago_venta`
  ADD CONSTRAINT `metodos_pago_venta_ibfk_1` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD CONSTRAINT `password_reset_tokens_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `productos_ibfk_1` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`) ON DELETE CASCADE;

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
  ADD CONSTRAINT `ventas_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
