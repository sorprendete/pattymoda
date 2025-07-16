-- Script SQL para agregar funcionalidad de recuperación de contraseña
-- Ejecutar en phpMyAdmin

-- Crear tabla para tokens de recuperación de contraseña
CREATE TABLE IF NOT EXISTS password_reset_tokens (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    usuario_id BIGINT NOT NULL,
    token VARCHAR(255) NOT NULL UNIQUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_expiracion TIMESTAMP NOT NULL,
    usado BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    INDEX idx_token (token),
    INDEX idx_usuario_id (usuario_id),
    INDEX idx_fecha_expiracion (fecha_expiracion)
);

-- Agregar campo para intentos de recuperación (opcional, para seguridad)
ALTER TABLE usuarios 
ADD COLUMN intentos_recuperacion INT DEFAULT 0,
ADD COLUMN ultimo_intento_recuperacion TIMESTAMP NULL;

-- Insertar datos de prueba actualizados para DPattyModa
UPDATE usuarios SET 
    nombre = 'Admin DPattyModa',
    email = 'admin@dpattymoda.com'
WHERE id = 1;

UPDATE usuarios SET 
    nombre = 'Vendedor DPattyModa', 
    email = 'vendedor@dpattymoda.com'
WHERE id = 2;

-- Actualizar configuración de tienda
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