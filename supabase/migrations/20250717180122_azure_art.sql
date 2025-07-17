-- Base de datos mejorada para DPattyModa
-- Versión optimizada con todas las mejoras y actualizaciones

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

-- Crear base de datos
CREATE DATABASE IF NOT EXISTS `pattymoda_mejorada` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `pattymoda_mejorada`;

-- --------------------------------------------------------
-- Tabla de usuarios mejorada
-- --------------------------------------------------------
CREATE TABLE `usuarios` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `rol` enum('SUPER_ADMIN','ADMIN','MANAGER','VENDEDOR','CAJERO','INVENTARIO') NOT NULL DEFAULT 'VENDEDOR',
  `telefono` varchar(20) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `ultimo_acceso` timestamp NULL DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `foto_perfil` varchar(255) DEFAULT NULL,
  `intentos_recuperacion` int(11) DEFAULT 0,
  `ultimo_intento_recuperacion` timestamp NULL DEFAULT NULL,
  `configuracion_usuario` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_usuarios_rol` (`rol`),
  KEY `idx_usuarios_activo` (`activo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabla de categorías mejorada
-- --------------------------------------------------------
CREATE TABLE `categorias` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `categoria_padre_id` bigint(20) DEFAULT NULL,
  `imagen` varchar(255) DEFAULT NULL,
  `orden` int(11) DEFAULT 0,
  `activo` tinyint(1) DEFAULT 1,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `creado_por` bigint(20) DEFAULT NULL,
  `modificado_por` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre_categoria_padre` (`nombre`, `categoria_padre_id`),
  KEY `idx_categorias_padre` (`categoria_padre_id`),
  KEY `idx_categorias_activo` (`activo`),
  KEY `idx_categorias_orden` (`orden`),
  CONSTRAINT `fk_categoria_padre` FOREIGN KEY (`categoria_padre_id`) REFERENCES `categorias` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_categoria_creador` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_categoria_modificador` FOREIGN KEY (`modificado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabla de productos mejorada
-- --------------------------------------------------------
CREATE TABLE `productos` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `sku` varchar(100) NOT NULL,
  `codigo_barras` varchar(50) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `descripcion_corta` varchar(500) DEFAULT NULL,
  `marca` varchar(100) DEFAULT NULL,
  `modelo` varchar(100) DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL,
  `precio_oferta` decimal(10,2) DEFAULT NULL,
  `costo` decimal(10,2) DEFAULT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  `stock_minimo` int(11) DEFAULT 5,
  `stock_maximo` int(11) DEFAULT NULL,
  `unidad_medida` varchar(20) DEFAULT 'UNIDAD',
  `peso` decimal(8,3) DEFAULT NULL,
  `dimensiones` varchar(100) DEFAULT NULL,
  `imagen_principal` varchar(255) DEFAULT NULL,
  `categoria_id` bigint(20) NOT NULL,
  `proveedor_id` bigint(20) DEFAULT NULL,
  `ubicacion_almacen` varchar(100) DEFAULT NULL,
  `fecha_vencimiento` date DEFAULT NULL,
  `es_perecedero` tinyint(1) DEFAULT 0,
  `requiere_talla` tinyint(1) DEFAULT 1,
  `requiere_color` tinyint(1) DEFAULT 1,
  `destacado` tinyint(1) DEFAULT 0,
  `nuevo` tinyint(1) DEFAULT 1,
  `en_oferta` tinyint(1) DEFAULT 0,
  `activo` tinyint(1) DEFAULT 1,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `creado_por` bigint(20) DEFAULT NULL,
  `modificado_por` bigint(20) DEFAULT NULL,
  `meta_title` varchar(255) DEFAULT NULL,
  `meta_description` varchar(500) DEFAULT NULL,
  `tags` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sku` (`sku`),
  UNIQUE KEY `codigo_barras` (`codigo_barras`),
  KEY `idx_productos_categoria` (`categoria_id`),
  KEY `idx_productos_activo` (`activo`),
  KEY `idx_productos_stock` (`stock`),
  KEY `idx_productos_precio` (`precio`),
  KEY `idx_productos_destacado` (`destacado`),
  KEY `idx_productos_oferta` (`en_oferta`),
  KEY `idx_productos_marca` (`marca`),
  CONSTRAINT `fk_producto_categoria` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_producto_creador` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_producto_modificador` FOREIGN KEY (`modificado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabla de tallas de productos
-- --------------------------------------------------------
CREATE TABLE `producto_tallas` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `producto_id` bigint(20) NOT NULL,
  `talla` varchar(10) NOT NULL,
  `stock_talla` int(11) NOT NULL DEFAULT 0,
  `precio_adicional` decimal(10,2) DEFAULT 0.00,
  `activo` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_producto_talla` (`producto_id`, `talla`),
  KEY `idx_producto_tallas_producto` (`producto_id`),
  CONSTRAINT `fk_producto_talla` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabla de colores de productos
-- --------------------------------------------------------
CREATE TABLE `producto_colores` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `producto_id` bigint(20) NOT NULL,
  `color` varchar(50) NOT NULL,
  `codigo_hex` varchar(7) DEFAULT '#000000',
  `stock_color` int(11) NOT NULL DEFAULT 0,
  `precio_adicional` decimal(10,2) DEFAULT 0.00,
  `activo` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_producto_color` (`producto_id`, `color`),
  KEY `idx_producto_colores_producto` (`producto_id`),
  CONSTRAINT `fk_producto_color` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabla de imágenes de productos
-- --------------------------------------------------------
CREATE TABLE `producto_imagenes` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `producto_id` bigint(20) NOT NULL,
  `url_imagen` varchar(255) NOT NULL,
  `alt_text` varchar(255) DEFAULT NULL,
  `orden` int(11) DEFAULT 0,
  `es_principal` tinyint(1) DEFAULT 0,
  `activo` tinyint(1) DEFAULT 1,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_producto_imagenes_producto` (`producto_id`),
  KEY `idx_producto_imagenes_principal` (`es_principal`),
  CONSTRAINT `fk_producto_imagen` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabla de clientes mejorada
-- --------------------------------------------------------
CREATE TABLE `clientes` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `codigo_cliente` varchar(20) DEFAULT NULL,
  `tipo_documento` enum('DNI','RUC','PASAPORTE','CARNET_EXTRANJERIA') DEFAULT 'DNI',
  `numero_documento` varchar(20) DEFAULT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) DEFAULT NULL,
  `razon_social` varchar(200) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `telefono_secundario` varchar(20) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `distrito` varchar(100) DEFAULT NULL,
  `provincia` varchar(100) DEFAULT NULL,
  `departamento` varchar(100) DEFAULT 'Loreto',
  `codigo_postal` varchar(10) DEFAULT NULL,
  `pais` varchar(50) DEFAULT 'Perú',
  `fecha_nacimiento` date DEFAULT NULL,
  `genero` enum('M','F','OTRO') DEFAULT NULL,
  `estado_civil` enum('SOLTERO','CASADO','DIVORCIADO','VIUDO','OTRO') DEFAULT NULL,
  `ocupacion` varchar(100) DEFAULT NULL,
  `tipo_cliente` enum('REGULAR','VIP','MAYORISTA','MINORISTA') DEFAULT 'REGULAR',
  `limite_credito` decimal(10,2) DEFAULT 0.00,
  `descuento_personalizado` decimal(5,2) DEFAULT 0.00,
  `metodo_pago_preferido` enum('EFECTIVO','TARJETA','YAPE','PLIN','TRANSFERENCIA') DEFAULT 'EFECTIVO',
  `total_compras` decimal(12,2) DEFAULT 0.00,
  `cantidad_compras` int(11) DEFAULT 0,
  `ultima_compra` timestamp NULL DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `activo` tinyint(1) DEFAULT 1,
  `notas` text DEFAULT NULL,
  `preferencias` json DEFAULT NULL,
  `creado_por` bigint(20) DEFAULT NULL,
  `modificado_por` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `codigo_cliente` (`codigo_cliente`),
  KEY `idx_clientes_documento` (`tipo_documento`, `numero_documento`),
  KEY `idx_clientes_tipo` (`tipo_cliente`),
  KEY `idx_clientes_activo` (`activo`),
  KEY `idx_clientes_total_compras` (`total_compras`),
  CONSTRAINT `fk_cliente_creador` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_cliente_modificador` FOREIGN KEY (`modificado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabla de configuración de impuestos mejorada
-- --------------------------------------------------------
CREATE TABLE `configuracion_impuestos` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `codigo` varchar(10) NOT NULL,
  `porcentaje` decimal(5,2) NOT NULL,
  `tipo` enum('IGV','ISC','MUNICIPAL','OTROS') DEFAULT 'OTROS',
  `activo` tinyint(1) DEFAULT 1,
  `aplicar_por_defecto` tinyint(1) DEFAULT 0,
  `aplica_a_productos` tinyint(1) DEFAULT 1,
  `aplica_a_servicios` tinyint(1) DEFAULT 1,
  `descripcion` varchar(200) DEFAULT NULL,
  `base_legal` varchar(500) DEFAULT NULL,
  `fecha_vigencia_inicio` date DEFAULT NULL,
  `fecha_vigencia_fin` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `creado_por` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo` (`codigo`),
  KEY `idx_impuestos_activo` (`activo`),
  KEY `idx_impuestos_por_defecto` (`aplicar_por_defecto`),
  KEY `idx_impuestos_tipo` (`tipo`),
  CONSTRAINT `fk_impuesto_creador` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabla de ventas mejorada
-- --------------------------------------------------------
CREATE TABLE `ventas` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `numero_venta` varchar(20) NOT NULL,
  `cliente_id` bigint(20) NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp(),
  `subtotal` decimal(12,2) NOT NULL DEFAULT 0.00,
  `descuento_porcentaje` decimal(5,2) DEFAULT 0.00,
  `descuento_monto` decimal(10,2) NOT NULL DEFAULT 0.00,
  `impuesto_porcentaje` decimal(5,2) DEFAULT 0.00,
  `impuesto_monto` decimal(10,2) NOT NULL DEFAULT 0.00,
  `total` decimal(12,2) NOT NULL,
  `estado` enum('PENDIENTE','PAGADA','PARCIALMENTE_PAGADA','ANULADA','DEVUELTA') NOT NULL DEFAULT 'PENDIENTE',
  `tipo_comprobante` enum('BOLETA','FACTURA','NOTA_VENTA') DEFAULT 'BOLETA',
  `serie_comprobante` varchar(10) DEFAULT NULL,
  `numero_comprobante` varchar(20) DEFAULT NULL,
  `moneda` varchar(3) DEFAULT 'PEN',
  `tipo_cambio` decimal(8,4) DEFAULT 1.0000,
  `observaciones` text DEFAULT NULL,
  `notas_internas` text DEFAULT NULL,
  `canal_venta` enum('TIENDA','ONLINE','TELEFONO','WHATSAPP','FACEBOOK','INSTAGRAM') DEFAULT 'TIENDA',
  `vendedor_id` bigint(20) DEFAULT NULL,
  `cajero_id` bigint(20) DEFAULT NULL,
  `fecha_vencimiento` date DEFAULT NULL,
  `fecha_entrega` date DEFAULT NULL,
  `direccion_entrega` varchar(500) DEFAULT NULL,
  `costo_envio` decimal(10,2) DEFAULT 0.00,
  `peso_total` decimal(8,3) DEFAULT NULL,
  `cantidad_items` int(11) DEFAULT 0,
  `fecha_actualizacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `creado_por` bigint(20) DEFAULT NULL,
  `modificado_por` bigint(20) DEFAULT NULL,
  `datos_adicionales` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `numero_venta` (`numero_venta`),
  KEY `idx_ventas_cliente` (`cliente_id`),
  KEY `idx_ventas_estado` (`estado`),
  KEY `idx_ventas_fecha` (`fecha`),
  KEY `idx_ventas_vendedor` (`vendedor_id`),
  KEY `idx_ventas_total` (`total`),
  KEY `idx_ventas_comprobante` (`tipo_comprobante`, `serie_comprobante`, `numero_comprobante`),
  CONSTRAINT `fk_venta_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_venta_vendedor` FOREIGN KEY (`vendedor_id`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_venta_cajero` FOREIGN KEY (`cajero_id`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_venta_creador` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabla de detalle de ventas mejorada
-- --------------------------------------------------------
CREATE TABLE `detalle_venta` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `venta_id` bigint(20) NOT NULL,
  `producto_id` bigint(20) NOT NULL,
  `cantidad` decimal(10,3) NOT NULL,
  `talla` varchar(10) DEFAULT NULL,
  `color` varchar(50) DEFAULT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `precio_original` decimal(10,2) DEFAULT NULL,
  `descuento_porcentaje` decimal(5,2) DEFAULT 0.00,
  `descuento_monto` decimal(10,2) DEFAULT 0.00,
  `subtotal` decimal(12,2) GENERATED ALWAYS AS ((`cantidad` * `precio_unitario`) - `descuento_monto`) STORED,
  `costo_unitario` decimal(10,2) DEFAULT NULL,
  `margen_ganancia` decimal(10,2) GENERATED ALWAYS AS (`precio_unitario` - `costo_unitario`) STORED,
  `notas` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_detalle_venta` (`venta_id`),
  KEY `idx_detalle_producto` (`producto_id`),
  CONSTRAINT `fk_detalle_venta` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_detalle_producto` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabla de métodos de pago por venta
-- --------------------------------------------------------
CREATE TABLE `metodos_pago_venta` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `venta_id` bigint(20) NOT NULL,
  `tipo_pago` enum('EFECTIVO','TARJETA_DEBITO','TARJETA_CREDITO','YAPE','PLIN','TRANSFERENCIA','CHEQUE','CREDITO') NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `referencia` varchar(100) DEFAULT NULL,
  `numero_operacion` varchar(50) DEFAULT NULL,
  `banco` varchar(100) DEFAULT NULL,
  `tipo_tarjeta` varchar(50) DEFAULT NULL,
  `ultimos_4_digitos` varchar(4) DEFAULT NULL,
  `fecha_vencimiento_tarjeta` varchar(7) DEFAULT NULL,
  `numero_cuotas` int(11) DEFAULT 1,
  `tasa_interes` decimal(5,2) DEFAULT 0.00,
  `comision` decimal(10,2) DEFAULT 0.00,
  `estado` enum('PENDIENTE','APROBADO','RECHAZADO','ANULADO') DEFAULT 'APROBADO',
  `fecha_pago` timestamp NOT NULL DEFAULT current_timestamp(),
  `notas` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_metodos_pago_venta` (`venta_id`),
  KEY `idx_metodos_pago_tipo` (`tipo_pago`),
  CONSTRAINT `fk_metodo_pago_venta` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabla de tokens de recuperación de contraseña
-- --------------------------------------------------------
CREATE TABLE `password_reset_tokens` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `usuario_id` bigint(20) NOT NULL,
  `token` varchar(255) NOT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_expiracion` timestamp NOT NULL,
  `usado` tinyint(1) DEFAULT 0,
  `ip_solicitud` varchar(45) DEFAULT NULL,
  `user_agent` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `idx_token_usuario` (`usuario_id`),
  KEY `idx_token_expiracion` (`fecha_expiracion`),
  CONSTRAINT `fk_token_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabla de configuración de la tienda
-- --------------------------------------------------------
CREATE TABLE `configuracion_tienda` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `slogan` varchar(200) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `ruc` varchar(11) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `distrito` varchar(100) DEFAULT NULL,
  `provincia` varchar(100) DEFAULT NULL,
  `departamento` varchar(100) DEFAULT NULL,
  `codigo_postal` varchar(10) DEFAULT NULL,
  `pais` varchar(50) DEFAULT 'Perú',
  `telefono` varchar(20) DEFAULT NULL,
  `telefono_secundario` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `email_ventas` varchar(100) DEFAULT NULL,
  `email_soporte` varchar(100) DEFAULT NULL,
  `sitio_web` varchar(100) DEFAULT NULL,
  `facebook` varchar(100) DEFAULT NULL,
  `instagram` varchar(100) DEFAULT NULL,
  `whatsapp` varchar(20) DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `favicon` varchar(255) DEFAULT NULL,
  `horario_atencion` json DEFAULT NULL,
  `moneda_principal` varchar(3) DEFAULT 'PEN',
  `idioma_principal` varchar(5) DEFAULT 'es_PE',
  `zona_horaria` varchar(50) DEFAULT 'America/Lima',
  `configuracion_facturacion` json DEFAULT NULL,
  `configuracion_notificaciones` json DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabla de proveedores
-- --------------------------------------------------------
CREATE TABLE `proveedores` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `codigo_proveedor` varchar(20) DEFAULT NULL,
  `razon_social` varchar(200) NOT NULL,
  `nombre_comercial` varchar(200) DEFAULT NULL,
  `ruc` varchar(11) DEFAULT NULL,
  `tipo_documento` enum('RUC','DNI','PASAPORTE') DEFAULT 'RUC',
  `numero_documento` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `distrito` varchar(100) DEFAULT NULL,
  `provincia` varchar(100) DEFAULT NULL,
  `departamento` varchar(100) DEFAULT NULL,
  `pais` varchar(50) DEFAULT 'Perú',
  `contacto_principal` varchar(100) DEFAULT NULL,
  `telefono_contacto` varchar(20) DEFAULT NULL,
  `email_contacto` varchar(100) DEFAULT NULL,
  `condiciones_pago` varchar(200) DEFAULT NULL,
  `tiempo_entrega_dias` int(11) DEFAULT NULL,
  `calificacion` decimal(3,2) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `notas` text DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `creado_por` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo_proveedor` (`codigo_proveedor`),
  KEY `idx_proveedores_activo` (`activo`),
  CONSTRAINT `fk_proveedor_creador` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabla de movimientos de inventario
-- --------------------------------------------------------
CREATE TABLE `movimientos_inventario` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `producto_id` bigint(20) NOT NULL,
  `tipo_movimiento` enum('ENTRADA','SALIDA','AJUSTE','TRANSFERENCIA','DEVOLUCION') NOT NULL,
  `motivo` enum('COMPRA','VENTA','AJUSTE_INVENTARIO','MERMA','ROBO','DEVOLUCION_CLIENTE','DEVOLUCION_PROVEEDOR','PROMOCION','MUESTRA','OTROS') NOT NULL,
  `cantidad_anterior` int(11) NOT NULL,
  `cantidad_movimiento` int(11) NOT NULL,
  `cantidad_actual` int(11) NOT NULL,
  `costo_unitario` decimal(10,2) DEFAULT NULL,
  `valor_total` decimal(12,2) DEFAULT NULL,
  `referencia_documento` varchar(100) DEFAULT NULL,
  `venta_id` bigint(20) DEFAULT NULL,
  `proveedor_id` bigint(20) DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `fecha_movimiento` timestamp NOT NULL DEFAULT current_timestamp(),
  `usuario_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_movimientos_producto` (`producto_id`),
  KEY `idx_movimientos_tipo` (`tipo_movimiento`),
  KEY `idx_movimientos_fecha` (`fecha_movimiento`),
  KEY `idx_movimientos_usuario` (`usuario_id`),
  KEY `idx_movimientos_venta` (`venta_id`),
  CONSTRAINT `fk_movimiento_producto` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_movimiento_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_movimiento_venta` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_movimiento_proveedor` FOREIGN KEY (`proveedor_id`) REFERENCES `proveedores` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabla de sesiones de usuario
-- --------------------------------------------------------
CREATE TABLE `sesiones_usuario` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `usuario_id` bigint(20) NOT NULL,
  `token_sesion` varchar(255) NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(500) DEFAULT NULL,
  `fecha_inicio` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_ultimo_acceso` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `fecha_expiracion` timestamp NOT NULL,
  `activa` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token_sesion` (`token_sesion`),
  KEY `idx_sesiones_usuario` (`usuario_id`),
  KEY `idx_sesiones_activa` (`activa`),
  CONSTRAINT `fk_sesion_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Insertar datos iniciales
-- --------------------------------------------------------

-- Usuario super administrador
INSERT INTO `usuarios` (`nombre`, `apellido`, `email`, `password`, `rol`, `activo`) VALUES
('Super', 'Administrador', 'admin@dpattymoda.com', '$2a$10$UVF7iyQYdCWkqzXHFm77EOxpNwmUg1VqISzollJhWg8jlpVUD.Huu', 'SUPER_ADMIN', 1);

-- Configuración de impuestos para la región de la selva
INSERT INTO `configuracion_impuestos` (`nombre`, `codigo`, `porcentaje`, `tipo`, `activo`, `aplicar_por_defecto`, `descripcion`, `base_legal`) VALUES
('IGV Selva', 'IGV_SEL', 0.00, 'IGV', 1, 1, 'IGV para región de la selva - Exonerado según Ley de Promoción de la Inversión en la Amazonía', 'Ley N° 27037 - Ley de Promoción de la Inversión en la Amazonía'),
('IGV Estándar', 'IGV_STD', 18.00, 'IGV', 0, 0, 'IGV estándar del 18% para otras regiones del Perú', 'TUO del IGV - D.S. N° 055-99-EF'),
('ISC Textiles', 'ISC_TEX', 0.00, 'ISC', 0, 0, 'Impuesto Selectivo al Consumo para productos textiles', 'TUO del ISC - D.S. N° 055-99-EF');

-- Configuración de la tienda
INSERT INTO `configuracion_tienda` (`nombre`, `slogan`, `descripcion`, `direccion`, `distrito`, `provincia`, `departamento`, `telefono`, `email`, `whatsapp`, `horario_atencion`, `moneda_principal`) VALUES
('DPattyModa', 'Moda y Estilo en la Selva', 'Tienda especializada en ropa moderna y elegante ubicada en Pampa Hermosa, Loreto. Ofrecemos las últimas tendencias en moda femenina y masculina.', 'Av. Principal 123', 'Pampa Hermosa', 'Ucayali', 'Loreto', '+51 965 123 456', 'info@dpattymoda.com', '+51 965 123 456', '{"lunes_viernes": "9:00-20:00", "sabado": "9:00-21:00", "domingo": "10:00-18:00"}', 'PEN');

-- Categorías iniciales
INSERT INTO `categorias` (`nombre`, `descripcion`, `orden`, `activo`) VALUES
('Ropa Femenina', 'Toda la ropa para mujeres', 1, 1),
('Ropa Masculina', 'Ropa para hombres', 2, 1),
('Accesorios', 'Complementos y accesorios', 3, 1),
('Calzado', 'Zapatos y sandalias', 4, 1);

-- Subcategorías
INSERT INTO `categorias` (`nombre`, `descripcion`, `categoria_padre_id`, `orden`, `activo`) VALUES
('Blusas', 'Blusas elegantes y casuales', 1, 1, 1),
('Vestidos', 'Vestidos para toda ocasión', 1, 2, 1),
('Pantalones Femeninos', 'Pantalones y jeans para mujeres', 1, 3, 1),
('Faldas', 'Faldas modernas', 1, 4, 1),
('Camisas Masculinas', 'Camisas formales y casuales', 2, 1, 1),
('Pantalones Masculinos', 'Pantalones para hombres', 2, 2, 1),
('Polos', 'Polos deportivos y casuales', 2, 3, 1),
('Bolsos', 'Carteras y bolsos', 3, 1, 1),
('Cinturones', 'Cinturones de cuero y tela', 3, 2, 1),
('Joyas', 'Collares, pulseras y aretes', 3, 3, 1),
('Zapatos Formales', 'Zapatos para ocasiones especiales', 4, 1, 1),
('Zapatillas', 'Calzado deportivo y casual', 4, 2, 1),
('Sandalias', 'Sandalias y chanclas', 4, 3, 1);

-- --------------------------------------------------------
-- Triggers y funciones
-- --------------------------------------------------------

-- Trigger para generar número de venta automático
DELIMITER $$
CREATE TRIGGER `before_insert_venta` BEFORE INSERT ON `ventas` FOR EACH ROW 
BEGIN
    IF NEW.numero_venta IS NULL OR NEW.numero_venta = '' THEN
        SET NEW.numero_venta = CONCAT('V', YEAR(NOW()), LPAD(
            COALESCE(
                (SELECT MAX(CAST(SUBSTRING(numero_venta, 6) AS UNSIGNED))
                 FROM ventas 
                 WHERE numero_venta LIKE CONCAT('V', YEAR(NOW()), '%')), 0
            ) + 1, 6, '0'
        ));
    END IF;
END$$
DELIMITER ;

-- Trigger para generar código de cliente automático
DELIMITER $$
CREATE TRIGGER `before_insert_cliente` BEFORE INSERT ON `clientes` FOR EACH ROW 
BEGIN
    IF NEW.codigo_cliente IS NULL OR NEW.codigo_cliente = '' THEN
        SET NEW.codigo_cliente = CONCAT('CLI', LPAD(
            COALESCE(
                (SELECT MAX(CAST(SUBSTRING(codigo_cliente, 4) AS UNSIGNED))
                 FROM clientes 
                 WHERE codigo_cliente LIKE 'CLI%'), 0
            ) + 1, 6, '0'
        ));
    END IF;
END$$
DELIMITER ;

-- Trigger para actualizar stock después de venta
DELIMITER $$
CREATE TRIGGER `after_insert_detalle_venta` AFTER INSERT ON `detalle_venta` FOR EACH ROW 
BEGIN
    -- Actualizar stock del producto
    UPDATE productos 
    SET stock = stock - NEW.cantidad 
    WHERE id = NEW.producto_id;
    
    -- Registrar movimiento de inventario
    INSERT INTO movimientos_inventario 
    (producto_id, tipo_movimiento, motivo, cantidad_anterior, cantidad_movimiento, cantidad_actual, venta_id, usuario_id)
    SELECT 
        NEW.producto_id,
        'SALIDA',
        'VENTA',
        p.stock + NEW.cantidad,
        NEW.cantidad,
        p.stock,
        NEW.venta_id,
        COALESCE((SELECT creado_por FROM ventas WHERE id = NEW.venta_id), 1)
    FROM productos p 
    WHERE p.id = NEW.producto_id;
END$$
DELIMITER ;

-- Trigger para actualizar totales del cliente
DELIMITER $$
CREATE TRIGGER `after_update_venta_pagada` AFTER UPDATE ON `ventas` FOR EACH ROW 
BEGIN
    IF OLD.estado != 'PAGADA' AND NEW.estado = 'PAGADA' THEN
        UPDATE clientes 
        SET 
            total_compras = total_compras + NEW.total,
            cantidad_compras = cantidad_compras + 1,
            ultima_compra = NEW.fecha
        WHERE id = NEW.cliente_id;
    END IF;
END$$
DELIMITER ;

-- --------------------------------------------------------
-- Vistas útiles
-- --------------------------------------------------------

-- Vista de productos con información completa
CREATE VIEW `vista_productos_completa` AS
SELECT 
    p.id,
    p.nombre,
    p.sku,
    p.descripcion,
    p.precio,
    p.precio_oferta,
    p.costo,
    p.stock,
    p.stock_minimo,
    p.imagen_principal,
    c.nombre AS categoria_nombre,
    c.id AS categoria_id,
    p.marca,
    p.activo,
    p.destacado,
    p.en_oferta,
    p.fecha_creacion,
    CASE 
        WHEN p.stock <= 0 THEN 'SIN_STOCK'
        WHEN p.stock <= p.stock_minimo THEN 'STOCK_BAJO'
        ELSE 'STOCK_OK'
    END AS estado_stock,
    ROUND(((p.precio - p.costo) / p.precio) * 100, 2) AS margen_porcentaje
FROM productos p
LEFT JOIN categorias c ON p.categoria_id = c.id;

-- Vista de ventas con información del cliente
CREATE VIEW `vista_ventas_completa` AS
SELECT 
    v.id,
    v.numero_venta,
    v.fecha,
    v.subtotal,
    v.descuento_monto,
    v.impuesto_monto,
    v.total,
    v.estado,
    v.tipo_comprobante,
    v.canal_venta,
    CONCAT(c.nombre, ' ', COALESCE(c.apellido, '')) AS cliente_nombre,
    c.email AS cliente_email,
    c.telefono AS cliente_telefono,
    CONCAT(u.nombre, ' ', COALESCE(u.apellido, '')) AS vendedor_nombre,
    v.cantidad_items,
    v.fecha_creacion
FROM ventas v
LEFT JOIN clientes c ON v.cliente_id = c.id
LEFT JOIN usuarios u ON v.vendedor_id = u.id;

-- Vista de clientes con estadísticas
CREATE VIEW `vista_clientes_estadisticas` AS
SELECT 
    c.id,
    c.codigo_cliente,
    c.nombre,
    c.apellido,
    c.email,
    c.telefono,
    c.tipo_cliente,
    c.total_compras,
    c.cantidad_compras,
    c.ultima_compra,
    c.activo,
    CASE 
        WHEN c.total_compras >= 5000 THEN 'VIP'
        WHEN c.total_compras >= 2000 THEN 'PREMIUM'
        WHEN c.total_compras >= 500 THEN 'REGULAR'
        ELSE 'NUEVO'
    END AS categoria_cliente,
    COALESCE(c.total_compras / NULLIF(c.cantidad_compras, 0), 0) AS ticket_promedio
FROM clientes c;

-- --------------------------------------------------------
-- Índices adicionales para optimización
-- --------------------------------------------------------

-- Índices para reportes y consultas frecuentes
CREATE INDEX `idx_ventas_fecha_estado` ON `ventas` (`fecha`, `estado`);
CREATE INDEX `idx_detalle_venta_producto_fecha` ON `detalle_venta` (`producto_id`, (SELECT fecha FROM ventas WHERE id = venta_id));
CREATE INDEX `idx_productos_categoria_activo` ON `productos` (`categoria_id`, `activo`);
CREATE INDEX `idx_clientes_total_compras_desc` ON `clientes` (`total_compras` DESC);

-- --------------------------------------------------------
-- Funciones útiles
-- --------------------------------------------------------

-- Función para obtener el IGV activo
DELIMITER $$
CREATE FUNCTION `obtener_igv_activo`() RETURNS DECIMAL(5,2)
DETERMINISTIC READS SQL DATA
BEGIN
    DECLARE porcentaje DECIMAL(5,2) DEFAULT 0.00;
    
    SELECT ci.porcentaje INTO porcentaje
    FROM configuracion_impuestos ci
    WHERE ci.tipo = 'IGV' 
      AND ci.activo = 1 
      AND ci.aplicar_por_defecto = 1
    LIMIT 1;
    
    RETURN COALESCE(porcentaje, 0.00);
END$$
DELIMITER ;

-- Función para calcular el siguiente número de venta
DELIMITER $$
CREATE FUNCTION `siguiente_numero_venta`() RETURNS VARCHAR(20)
DETERMINISTIC READS SQL DATA
BEGIN
    DECLARE siguiente VARCHAR(20);
    
    SELECT CONCAT('V', YEAR(NOW()), LPAD(
        COALESCE(
            MAX(CAST(SUBSTRING(numero_venta, 6) AS UNSIGNED)), 0
        ) + 1, 6, '0'
    )) INTO siguiente
    FROM ventas 
    WHERE numero_venta LIKE CONCAT('V', YEAR(NOW()), '%');
    
    RETURN siguiente;
END$$
DELIMITER ;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;