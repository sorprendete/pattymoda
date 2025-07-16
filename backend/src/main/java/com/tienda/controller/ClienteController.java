package com.tienda.controller;

import com.tienda.entity.Cliente;
import com.tienda.service.ClienteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import jakarta.validation.Valid;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.List;

@RestController
@RequestMapping("/api/clientes")
@Tag(name = "Clientes", description = "Gestión de clientes")
public class ClienteController {
    
    @Autowired
    private ClienteService clienteService;
    
    @GetMapping
    @Operation(summary = "Obtener todos los clientes", description = "Devuelve una lista de todos los clientes")
    public ResponseEntity<List<Cliente>> obtenerTodosLosClientes() {
        List<Cliente> clientes = clienteService.obtenerTodosLosClientes();
        return ResponseEntity.ok(clientes);
    }
    
    @GetMapping("/activos")
    @Operation(summary = "Obtener clientes activos", description = "Devuelve solo los clientes activos")
    public ResponseEntity<List<Cliente>> obtenerClientesActivos() {
        List<Cliente> clientes = clienteService.obtenerClientesActivos();
        return ResponseEntity.ok(clientes);
    }
    
    @GetMapping("/{id}")
    @Operation(summary = "Obtener cliente por ID", description = "Devuelve un cliente específico por su ID")
    public ResponseEntity<Cliente> obtenerClientePorId(@PathVariable Long id) {
        return clienteService.obtenerClientePorId(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
    
    @GetMapping("/buscar")
    @Operation(summary = "Buscar clientes", description = "Busca clientes por nombre")
    public ResponseEntity<List<Cliente>> buscarClientes(@RequestParam String nombre) {
        List<Cliente> clientes = clienteService.buscarClientesPorNombre(nombre);
        return ResponseEntity.ok(clientes);
    }
    
    @PostMapping
    @Operation(summary = "Crear cliente", description = "Crea un nuevo cliente")
    public ResponseEntity<Cliente> crearCliente(@Valid @RequestBody Cliente cliente) {
        try {
            Cliente nuevoCliente = clienteService.crearCliente(cliente);
            return ResponseEntity.ok(nuevoCliente);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    @PutMapping("/{id}")
    @Operation(summary = "Actualizar cliente", description = "Actualiza un cliente existente")
    public ResponseEntity<Cliente> actualizarCliente(@PathVariable Long id, @Valid @RequestBody Cliente cliente) {
        try {
            Cliente clienteActualizado = clienteService.actualizarCliente(id, cliente);
            return ResponseEntity.ok(clienteActualizado);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar cliente", description = "Marca un cliente como inactivo")
    public ResponseEntity<Void> eliminarCliente(@PathVariable Long id) {
        try {
            clienteService.eliminarCliente(id);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }
}