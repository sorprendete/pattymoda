// Lista de productos
import React, { useState } from "react";
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

interface Product {
  id: string;
  name: string;
  sku: string;
  category: string;
  price: number;
  stock: number;
  minStock: number;
  image: string;
  status: "active" | "inactive";
}

export function ProductList() {
  const [searchTerm, setSearchTerm] = useState("");
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [selectedProduct, setSelectedProduct] = useState<Product | null>(null);

  // Elimina cualquier array de productos mock, solo usa datos del backend...
  const products: Product[] = []; // Aquí se debe implementar la lógica para obtener los productos del backend

  const filteredProducts = products.filter(
    (product) =>
      product.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      product.sku.toLowerCase().includes(searchTerm.toLowerCase()) ||
      product.category.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const lowStockProducts = products.filter((p) => p.stock <= p.minStock);

  const handleEditProduct = (product: Product) => {
    setSelectedProduct(product);
    setIsModalOpen(true);
  };

  const handleNewProduct = () => {
    setSelectedProduct(null);
    setIsModalOpen(true);
  };

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
                src={product.image}
                alt={product.name}
                className="w-full h-48 object-cover rounded-t-xl"
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
                <Button variant="danger" size="sm" className="shadow-lg">
                  <Trash2 className="w-3 h-3" />
                </Button>
              </div>
              {product.stock <= product.minStock && (
                <div className="absolute top-2 left-2 bg-red-500 text-white px-2 py-1 rounded text-xs font-medium">
                  Stock Bajo
                </div>
              )}
            </div>

            <CardContent className="p-4">
              <div className="space-y-2">
                <div className="flex items-start justify-between">
                  <h3 className="font-semibold text-gray-900 line-clamp-2">
                    {product.name}
                  </h3>
                </div>

                <div className="flex items-center justify-between text-sm text-gray-500">
                  <span>{product.sku}</span>
                  <span className="bg-gray-100 px-2 py-1 rounded text-xs">
                    {product.category}
                  </span>
                </div>

                <div className="flex items-center justify-between">
                  <p className="text-xl font-bold text-gray-900">
                    S/ {product.price}
                  </p>
                  <div className="flex items-center space-x-1">
                    <Package className="w-4 h-4 text-gray-400" />
                    <span
                      className={`text-sm font-medium ${
                        product.stock <= product.minStock
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
                      product.stock <= product.minStock
                        ? "bg-red-500"
                        : "bg-green-500"
                    }`}
                    style={{
                      width: `${Math.min(
                        (product.stock / (product.minStock * 3)) * 100,
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

      {filteredProducts.length === 0 && (
        <Card>
          <CardContent className="text-center py-12">
            <Package className="w-12 h-12 text-gray-400 mx-auto mb-4" />
            <h3 className="text-lg font-medium text-gray-900 mb-2">
              No se encontraron productos
            </h3>
            <p className="text-gray-500 mb-4">
              Prueba con otros términos de búsqueda
            </p>
            <Button onClick={handleNewProduct}>Crear Primer Producto</Button>
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
          onSubmit={(data) => {
            console.log("Producto guardado:", data);
            setIsModalOpen(false);
          }}
          onCancel={() => setIsModalOpen(false)}
        />
      </Modal>
    </div>
  );
}
