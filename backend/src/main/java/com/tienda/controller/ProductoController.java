package com.tienda.controller;

import com.tienda.entity.Producto;
import com.tienda.service.ProductoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import jakarta.validation.Valid;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.List;

@RestController
@RequestMapping("/api/productos")
@Tag(name = "Productos", description = "Gestión de productos")
public class ProductoController {
    
    @Autowired
    private ProductoService productoService;
    
    @GetMapping
    @Operation(summary = "Obtener todos los productos", description = "Devuelve una lista de todos los productos")
    public ResponseEntity<List<Producto>> obtenerTodosLosProductos() {
        List<Producto> productos = productoService.obtenerTodosLosProductos();
        return ResponseEntity.ok(productos);
    }
    
    @GetMapping("/activos")
    @Operation(summary = "Obtener productos activos", description = "Devuelve solo los productos activos")
    public ResponseEntity<List<Producto>> obtenerProductosActivos() {
        List<Producto> productos = productoService.obtenerProductosActivos();
        return ResponseEntity.ok(productos);
    }
    
    @GetMapping("/{id}")
    @Operation(summary = "Obtener producto por ID", description = "Devuelve un producto específico por su ID")
    public ResponseEntity<Producto> obtenerProductoPorId(@PathVariable Long id) {
        return productoService.obtenerProductoPorId(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
    
    @GetMapping("/categoria/{categoriaId}")
    @Operation(summary = "Obtener productos por categoría", description = "Devuelve productos de una categoría específica")
    public ResponseEntity<List<Producto>> obtenerProductosPorCategoria(@PathVariable Long categoriaId) {
        List<Producto> productos = productoService.obtenerProductosPorCategoria(categoriaId);
        return ResponseEntity.ok(productos);
    }
    
    @GetMapping("/buscar")
    @Operation(summary = "Buscar productos", description = "Busca productos por nombre")
    public ResponseEntity<List<Producto>> buscarProductos(@RequestParam String nombre) {
        List<Producto> productos = productoService.buscarProductosPorNombre(nombre);
        return ResponseEntity.ok(productos);
    }
    
    @PostMapping
    @Operation(summary = "Crear producto", description = "Crea un nuevo producto")
    public ResponseEntity<Producto> crearProducto(@Valid @RequestBody Producto producto) {
        try {
            Producto nuevoProducto = productoService.crearProducto(producto);
            return ResponseEntity.ok(nuevoProducto);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    @PutMapping("/{id}")
    @Operation(summary = "Actualizar producto", description = "Actualiza un producto existente")
    public ResponseEntity<Producto> actualizarProducto(@PathVariable Long id, @Valid @RequestBody Producto producto) {
        try {
            Producto productoActualizado = productoService.actualizarProducto(id, producto);
            return ResponseEntity.ok(productoActualizado);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar producto", description = "Marca un producto como inactivo")
    public ResponseEntity<Void> eliminarProducto(@PathVariable Long id) {
        try {
            productoService.eliminarProducto(id);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    @GetMapping("/stock-bajo")
    @Operation(summary = "Productos con stock bajo", description = "Devuelve productos con stock menor al especificado")
    public ResponseEntity<List<Producto>> obtenerProductosConStockBajo(@RequestParam(defaultValue = "10") Integer stockMinimo) {
        List<Producto> productos = productoService.obtenerProductosConStockBajo(stockMinimo);
        return ResponseEntity.ok(productos);
    }
}