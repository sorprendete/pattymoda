package com.tienda.service;

import com.tienda.entity.Producto;
import com.tienda.repository.ProductoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class ProductoService {
    
    @Autowired
    private ProductoRepository productoRepository;
    
    public List<Producto> obtenerTodosLosProductos() {
        return productoRepository.findAll();
    }
    
    public List<Producto> obtenerProductosActivos() {
        return productoRepository.findByActivoTrue();
    }
    
    public Optional<Producto> obtenerProductoPorId(Long id) {
        return productoRepository.findById(id);
    }
    
    public List<Producto> obtenerProductosPorCategoria(Long categoriaId) {
        return productoRepository.findByCategoriaId(categoriaId);
    }
    
    public List<Producto> buscarProductosPorNombre(String nombre) {
        return productoRepository.findByNombreContainingIgnoreCase(nombre);
    }
    
    public Producto crearProducto(Producto producto) {
        return productoRepository.save(producto);
    }
    
    public Producto actualizarProducto(Long id, Producto productoActualizado) {
        Producto producto = productoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Producto no encontrado"));
        
        producto.setNombre(productoActualizado.getNombre());
        producto.setDescripcion(productoActualizado.getDescripcion());
        producto.setPrecio(productoActualizado.getPrecio());
        producto.setStock(productoActualizado.getStock());
        producto.setCategoria(productoActualizado.getCategoria());
        producto.setImagen(productoActualizado.getImagen());
        
        return productoRepository.save(producto);
    }
    
    public void eliminarProducto(Long id) {
        Producto producto = productoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Producto no encontrado"));
        producto.setActivo(false);
        productoRepository.save(producto);
    }
    
    public List<Producto> obtenerProductosConStockBajo(Integer stockMinimo) {
        return productoRepository.findProductosConStockBajo(stockMinimo);
    }
    
    public void actualizarStock(Long id, Integer nuevaCantidad) {
        Producto producto = productoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Producto no encontrado"));
        producto.setStock(nuevaCantidad);
        productoRepository.save(producto);
    }
}