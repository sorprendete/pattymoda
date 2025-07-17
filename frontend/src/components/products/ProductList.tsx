// Lista de productos conectada al backend
import React, { useState, useEffect } from "react";
import {
  Plus,
  Search,
  Filter,
  Edit,
  Trash2,
  Package,
  AlertTriangle,
} from "lucide-react";
import { Card, CardHeader, CardTitle, CardContent } from "../ui/Card";
import { Button } from "../ui/Button";
import { Input } from "../ui/Input";
import { Modal } from "../ui/Modal";
import { ProductForm } from "./ProductForm";
import { ProductService } from "../../services/productService";

interface Product {
  id: string;
  nombre: string;
  sku: string;
  descripcion: string;
  marca: string;
  precio: number;
  costo: number;
  stock: number;
  stockMinimo: number;
  imagen: string;
  categoria: {
    id: string;
    nombre: string;
  };
  activo: boolean;
  fechaCreacion: string;
}

export function ProductList() {
  const [searchTerm, setSearchTerm] = useState("");
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [selectedProduct, setSelectedProduct] = useState<Product | null>(null);
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Cargar productos desde el backend
  useEffect(() => {
    loadProducts();
  }, []);

  const loadProducts = async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await ProductService.getAllProducts();
      setProducts(response.data || []);
    } catch (err: any) {
      setError("Error al cargar productos: " + (err.message || "Error desconocido"));
      console.error("Error loading products:", err);
    } finally {
      setLoading(false);
    }
  };

  const filteredProducts = products.filter(
    (product) =>
      product.nombre.toLowerCase().includes(searchTerm.toLowerCase()) ||
      product.sku.toLowerCase().includes(searchTerm.toLowerCase()) ||
      product.categoria.nombre.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const lowStockProducts = products.filter((p) => p.stock <= p.stockMinimo);

  const handleEditProduct = (product: Product) => {
    setSelectedProduct(product);
    setIsModalOpen(true);
  };

  const handleNewProduct = () => {
    setSelectedProduct(null);
    setIsModalOpen(true);
  };

  const handleDeleteProduct = async (productId: string) => {
    if (window.confirm("¿Estás seguro de que deseas eliminar este producto?")) {
      try {
        await ProductService.deleteProduct(productId);
        await loadProducts(); // Recargar la lista
      } catch (err: any) {
        alert("Error al eliminar producto: " + (err.message || "Error desconocido"));
      }
    }
  };

  const handleSaveProduct = async (productData: any) => {
    try {
      if (selectedProduct) {
        await ProductService.updateProduct(selectedProduct.id, productData);
      } else {
        await ProductService.createProduct(productData);
      }
      setIsModalOpen(false);
      await loadProducts(); // Recargar la lista
    } catch (err: any) {
      alert("Error al guardar producto: " + (err.message || "Error desconocido"));
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-yellow-500"></div>
        <span className="ml-3 text-gray-600">Cargando productos...</span>
      </div>
    );
  }

  if (error) {
    return (
      <div className="text-center py-12">
        <div className="text-red-500 mb-4">{error}</div>
        <Button onClick={loadProducts}>Reintentar</Button>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Productos</h1>
          <p className="text-gray-600 mt-1">Gestiona tu inventario de ropa</p>
        </div>
        <Button
          onClick={handleNewProduct}
          leftIcon={<Plus className="w-4 h-4" />}
        >
          Nuevo Producto
        </Button>
      </div>

      {/* Estadísticas */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <Card className="p-4">
          <div className="flex items-center">
            <div className="p-2 bg-blue-100 rounded-lg">
              <Package className="w-6 h-6 text-blue-600" />
            </div>
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-500">Total Productos</p>
              <p className="text-2xl font-bold text-gray-900">{products.length}</p>
            </div>
          </div>
        </Card>

        <Card className="p-4">
          <div className="flex items-center">
            <div className="p-2 bg-green-100 rounded-lg">
              <Package className="w-6 h-6 text-green-600" />
            </div>
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-500">Productos Activos</p>
              <p className="text-2xl font-bold text-gray-900">
                {products.filter(p => p.activo).length}
              </p>
            </div>
          </div>
        </Card>

        <Card className="p-4">
          <div className="flex items-center">
            <div className="p-2 bg-red-100 rounded-lg">
              <AlertTriangle className="w-6 h-6 text-red-600" />
            </div>
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-500">Stock Bajo</p>
              <p className="text-2xl font-bold text-gray-900">{lowStockProducts.length}</p>
            </div>
          </div>
        </Card>

        <Card className="p-4">
          <div className="flex items-center">
            <div className="p-2 bg-yellow-100 rounded-lg">
              <Package className="w-6 h-6 text-yellow-600" />
            </div>
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-500">Valor Inventario</p>
              <p className="text-2xl font-bold text-gray-900">
                S/ {products.reduce((acc, p) => acc + (p.precio * p.stock), 0).toLocaleString()}
              </p>
            </div>
          </div>
        </Card>
      </div>

      {/* Alertas de Stock Bajo */}
      {lowStockProducts.length > 0 && (
        <Card className="border-l-4 border-l-red-500 bg-red-50">
          <div className="flex items-center p-4">
            <AlertTriangle className="w-5 h-5 text-red-500 mr-3" />
            <div className="flex-1">
              <p className="font-medium text-red-800">¡Atención! Stock Bajo</p>
              <p className="text-sm text-red-700">
                {lowStockProducts.length} productos necesitan reposición urgente
              </p>
            </div>
            <Button variant="outline" size="sm">
              Ver Productos
            </Button>
          </div>
        </Card>
      )}

      {/* Filtros y Búsqueda */}
      <Card>
        <CardContent className="p-4">
          <div className="flex flex-col sm:flex-row gap-4">
            <div className="flex-1">
              <Input
                placeholder="Buscar productos por nombre, SKU o categoría..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                leftIcon={<Search className="w-4 h-4 text-gray-400" />}
              />
            </div>
            <Button variant="outline" leftIcon={<Filter className="w-4 h-4" />}>
              Filtros
            </Button>
          </div>
        </CardContent>
      </Card>

      {/* Lista de Productos */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
        {filteredProducts.map((product) => (
          <Card
            key={product.id}
            className="group hover:shadow-lg transition-all duration-200"
          >
            <div className="relative">
              <img
                src={product.imagen || 'https://images.pexels.com/photos/1536619/pexels-photo-1536619.jpeg?auto=compress&cs=tinysrgb&w=300&h=200&dpr=2'}
                alt={product.nombre}
                className="w-full h-48 object-cover rounded-t-xl"
                onError={(e) => {
                  (e.target as HTMLImageElement).src = 'https://images.pexels.com/photos/1536619/pexels-photo-1536619.jpeg?auto=compress&cs=tinysrgb&w=300&h=200&dpr=2';
                }}
              />
              <div className="absolute top-2 right-2 opacity-0 group-hover:opacity-100 transition-opacity flex space-x-1">
                <Button
                  variant="secondary"
                  size="sm"
                  onClick={() => handleEditProduct(product)}
                  className="shadow-lg"
                >
                  <Edit className="w-3 h-3" />
                </Button>
                <Button 
                  variant="danger" 
                  size="sm" 
                  className="shadow-lg"
                  onClick={() => handleDeleteProduct(product.id)}
                >
                  <Trash2 className="w-3 h-3" />
                </Button>
              </div>
              {product.stock <= product.stockMinimo && (
                <div className="absolute top-2 left-2 bg-red-500 text-white px-2 py-1 rounded text-xs font-medium">
                  Stock Bajo
                </div>
              )}
            </div>

            <CardContent className="p-4">
              <div className="space-y-2">
                <div className="flex items-start justify-between">
                  <h3 className="font-semibold text-gray-900 line-clamp-2">
                    {product.nombre}
                  </h3>
                </div>

                <div className="flex items-center justify-between text-sm text-gray-500">
                  <span>{product.sku}</span>
                  <span className="bg-gray-100 px-2 py-1 rounded text-xs">
                    {product.categoria.nombre}
                  </span>
                </div>

                <div className="flex items-center justify-between">
                  <p className="text-xl font-bold text-gray-900">
                    S/ {product.precio.toFixed(2)}
                  </p>
                  <div className="flex items-center space-x-1">
                    <Package className="w-4 h-4 text-gray-400" />
                    <span
                      className={`text-sm font-medium ${
                        product.stock <= product.stockMinimo
                          ? "text-red-600"
                          : "text-gray-600"
                      }`}
                    >
                      {product.stock}
                    </span>
                  </div>
                </div>

                <div className="w-full bg-gray-200 rounded-full h-2">
                  <div
                    className={`h-2 rounded-full ${
                      product.stock <= product.stockMinimo
                        ? "bg-red-500"
                        : "bg-green-500"
                    }`}
                    style={{
                      width: `${Math.min(
                        (product.stock / (product.stockMinimo * 3)) * 100,
                        100
                      )}%`,
                    }}
                  ></div>
                </div>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      {filteredProducts.length === 0 && !loading && (
        <Card>
          <CardContent className="text-center py-12">
            <Package className="w-12 h-12 text-gray-400 mx-auto mb-4" />
            <h3 className="text-lg font-medium text-gray-900 mb-2">
              No se encontraron productos
            </h3>
            <p className="text-gray-500 mb-4">
              {searchTerm ? "Prueba con otros términos de búsqueda" : "Comienza agregando tu primer producto"}
            </p>
            <Button onClick={handleNewProduct}>
              {searchTerm ? "Limpiar búsqueda" : "Crear Primer Producto"}
            </Button>
          </CardContent>
        </Card>
      )}

      {/* Modal de Producto */}
      <Modal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        title={selectedProduct ? "Editar Producto" : "Nuevo Producto"}
        size="lg"
      >
        <ProductForm
          product={selectedProduct}
          onSubmit={handleSaveProduct}
          onCancel={() => setIsModalOpen(false)}
        />
      </Modal>
    </div>
  );
}