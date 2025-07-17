# DPattyModa - Sistema de Gestión Mejorado

Sistema completo de gestión para tienda de ropa ubicada en Pampa Hermosa, Loreto, Perú. Versión mejorada con base de datos optimizada y frontend completamente conectado al backend.

## 🚀 Características Principales

### ✨ Nuevas Mejoras
- **Base de datos completamente rediseñada** con optimizaciones y nuevas funcionalidades
- **Frontend conectado 100% al backend** - eliminados todos los datos de ejemplo
- **Sistema de roles mejorado** con permisos granulares
- **Gestión avanzada de inventario** con movimientos y trazabilidad
- **Sistema de impuestos configurable** adaptado para la región de la selva
- **Interfaz de usuario mejorada** con mejor UX/UI
- **Reportes y analytics en tiempo real** basados en datos reales

### 🏪 Gestión de Tienda
- **Productos**: Gestión completa con categorías, tallas, colores, stock
- **Clientes**: Base de datos de clientes con historial de compras
- **Ventas**: Sistema POS con múltiples métodos de pago
- **Inventario**: Control de stock con alertas automáticas
- **Reportes**: Analytics avanzados y reportes detallados

### 👥 Sistema de Usuarios
- **Super Administrador**: Acceso total al sistema
- **Administrador**: Gestión completa excepto configuración crítica
- **Gerente**: Supervisión de operaciones y reportes
- **Vendedor**: Ventas y gestión de clientes
- **Cajero**: Procesamiento de ventas
- **Inventario**: Gestión de productos y stock

### 💰 Sistema de Impuestos
- **IGV configurable** adaptado para la región de la selva (0% por defecto)
- **Múltiples impuestos** configurables según necesidades
- **Aplicación automática** en ventas según configuración

## 🛠️ Tecnologías

### Backend
- **Java 17** con Spring Boot 3.2
- **Spring Security** para autenticación y autorización
- **Spring Data JPA** para persistencia
- **MySQL** como base de datos principal
- **JWT** para manejo de sesiones
- **Swagger/OpenAPI** para documentación de API

### Frontend
- **React 18** con TypeScript
- **Vite** como bundler
- **Tailwind CSS** para estilos
- **Lucide React** para iconos
- **Recharts** para gráficos y visualizaciones

## 📦 Instalación

### Prerrequisitos
- Java 17+
- Node.js 18+
- MySQL 8.0+
- Maven 3.8+

### 1. Base de Datos
```sql
-- Ejecutar el script de la nueva base de datos
mysql -u root -p < database/pattymoda_mejorada.sql
```

### 2. Backend
```bash
cd backend
mvn clean install
mvn spring-boot:run
```

### 3. Frontend
```bash
cd frontend
npm install
npm run dev
```

## 🔧 Configuración

### Variables de Entorno
Copia `.env.example` a `.env` y configura:

```env
VITE_API_URL=http://localhost:8080/api
VITE_APP_NAME=DPattyModa
VITE_APP_VERSION=2.0.0
```

### Base de Datos
Actualiza `backend/src/main/resources/application.properties`:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/pattymoda_mejorada
spring.datasource.username=root
spring.datasource.password=tu_password
```

## 🎯 Funcionalidades Principales

### Dashboard
- Estadísticas en tiempo real
- Alertas de stock bajo
- Resumen de ventas del día
- Acciones rápidas

### Gestión de Productos
- CRUD completo de productos
- Gestión de categorías jerárquicas
- Control de stock con alertas
- Múltiples imágenes por producto
- Tallas y colores configurables

### Gestión de Clientes
- Registro completo de clientes
- Historial de compras
- Segmentación automática (VIP, Regular, Nuevo)
- Métodos de pago preferidos

### Sistema de Ventas
- POS intuitivo y rápido
- Múltiples métodos de pago combinados
- Aplicación automática de impuestos
- Descuentos configurables
- Generación de comprobantes

### Reportes y Analytics
- Gráficos interactivos en tiempo real
- Análisis de ventas por período
- Segmentación de clientes
- Rendimiento por categorías
- Exportación a PDF/Excel

## 🔐 Seguridad

- Autenticación JWT
- Autorización basada en roles
- Encriptación de contraseñas
- Recuperación de contraseña por email
- Sesiones seguras con expiración

## 📊 Base de Datos Mejorada

### Nuevas Características
- **Triggers automáticos** para numeración y stock
- **Vistas optimizadas** para consultas frecuentes
- **Índices mejorados** para mejor rendimiento
- **Campos adicionales** para mayor funcionalidad
- **Relaciones optimizadas** con integridad referencial

### Tablas Principales
- `usuarios` - Sistema de usuarios con roles
- `productos` - Inventario completo
- `categorias` - Organización jerárquica
- `clientes` - Base de datos de clientes
- `ventas` - Transacciones de venta
- `configuracion_impuestos` - Sistema fiscal configurable

## 🚀 Despliegue

### Producción
1. Configurar base de datos en servidor
2. Compilar backend: `mvn clean package`
3. Compilar frontend: `npm run build`
4. Desplegar en servidor web

### Docker (Opcional)
```bash
# Construir imágenes
docker-compose build

# Ejecutar servicios
docker-compose up -d
```

## 📝 Credenciales por Defecto

**Super Administrador:**
- Email: `admin@dpattymoda.com`
- Password: `admin123`

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## 📞 Soporte

Para soporte técnico o consultas:
- Email: info@dpattymoda.com
- Teléfono: +51 965 123 456
- Ubicación: Pampa Hermosa, Loreto, Perú

---

**DPattyModa** - Moda y Estilo en la Selva 🌿👗