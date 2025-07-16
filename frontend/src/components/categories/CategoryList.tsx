// Gestión de categorías
import React, { useState } from 'react';
import { Plus, Search, Edit, Trash2, Tag, ChevronRight, Folder, FolderOpen } from 'lucide-react';
import { Card, CardHeader, CardTitle, CardContent } from '../ui/Card';
import { Button } from '../ui/Button';
import { Input } from '../ui/Input';
import { Modal } from '../ui/Modal';

interface Category {
  id: string;
  name: string;
  description: string;
  parentId?: string;
  productCount: number;
  isActive: boolean;
  children?: Category[];
}

export function CategoryList() {
  const [searchTerm, setSearchTerm] = useState('');
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [selectedCategory, setSelectedCategory] = useState<Category | null>(null);
  const [expandedCategories, setExpandedCategories] = useState<Set<string>>(new Set());

  // Datos simulados con estructura jerárquica
  const categories: Category[] = [
    {
      id: '1',
      name: 'Ropa Femenina',
      description: 'Toda la ropa para mujeres',
      productCount: 156,
      isActive: true,
      children: [
        { id: '1-1', name: 'Blusas', description: 'Blusas elegantes y casuales', parentId: '1', productCount: 45, isActive: true },
        { id: '1-2', name: 'Vestidos', description: 'Vestidos para toda ocasión', parentId: '1', productCount: 32, isActive: true },
        { id: '1-3', name: 'Faldas', description: 'Faldas modernas', parentId: '1', productCount: 28, isActive: true },
        { id: '1-4', name: 'Pantalones', description: 'Pantalones y jeans', parentId: '1', productCount: 51, isActive: true },
      ]
    },
    {
      id: '2',
      name: 'Ropa Masculina',
      description: 'Ropa para hombres',
      productCount: 89,
      isActive: true,
      children: [
        { id: '2-1', name: 'Camisas', description: 'Camisas formales y casuales', parentId: '2', productCount: 34, isActive: true },
        { id: '2-2', name: 'Pantalones', description: 'Pantalones masculinos', parentId: '2', productCount: 28, isActive: true },
        { id: '2-3', name: 'Polos', description: 'Polos deportivos y casuales', parentId: '2', productCount: 27, isActive: true },
      ]
    },
    {
      id: '3',
      name: 'Accesorios',
      description: 'Complementos y accesorios',
      productCount: 67,
      isActive: true,
      children: [
        { id: '3-1', name: 'Bolsos', description: 'Carteras y bolsos', parentId: '3', productCount: 23, isActive: true },
        { id: '3-2', name: 'Cinturones', description: 'Cinturones de cuero y tela', parentId: '3', productCount: 18, isActive: true },
        { id: '3-3', name: 'Joyas', description: 'Collares, pulseras y aretes', parentId: '3', productCount: 26, isActive: true },
      ]
    },
    {
      id: '4',
      name: 'Calzado',
      description: 'Zapatos y sandalias',
      productCount: 45,
      isActive: true,
      children: [
        { id: '4-1', name: 'Zapatos Formales', description: 'Zapatos para ocasiones especiales', parentId: '4', productCount: 15, isActive: true },
        { id: '4-2', name: 'Zapatillas', description: 'Calzado deportivo y casual', parentId: '4', productCount: 20, isActive: true },
        { id: '4-3', name: 'Sandalias', description: 'Sandalias y chanclas', parentId: '4', productCount: 10, isActive: true },
      ]
    }
  ];

  const toggleExpanded = (categoryId: string) => {
    const newExpanded = new Set(expandedCategories);
    if (newExpanded.has(categoryId)) {
      newExpanded.delete(categoryId);
    } else {
      newExpanded.add(categoryId);
    }
    setExpandedCategories(newExpanded);
  };

  const handleEditCategory = (category: Category) => {
    setSelectedCategory(category);
    setIsModalOpen(true);
  };

  const handleNewCategory = () => {
    setSelectedCategory(null);
    setIsModalOpen(true);
  };

  const renderCategory = (category: Category, level: number = 0) => (
    <div key={category.id} className="space-y-2">
      <div 
        className={`flex items-center justify-between p-4 bg-white rounded-lg border hover:shadow-md transition-all duration-200 ${
          level > 0 ? 'ml-8 border-l-4 border-l-yellow-400' : 'shadow-sm'
        }`}
      >
        <div className="flex items-center space-x-3">
          {category.children && category.children.length > 0 && (
            <button
              onClick={() => toggleExpanded(category.id)}
              className="p-1 hover:bg-gray-100 rounded"
            >
              <ChevronRight 
                className={`w-4 h-4 transition-transform ${
                  expandedCategories.has(category.id) ? 'rotate-90' : ''
                }`} 
              />
            </button>
          )}
          
          <div className="p-2 bg-yellow-100 rounded-lg">
            {expandedCategories.has(category.id) ? (
              <FolderOpen className="w-5 h-5 text-yellow-600" />
            ) : (
              <Folder className="w-5 h-5 text-yellow-600" />
            )}
          </div>
          
          <div>
            <h3 className="font-semibold text-gray-900">{category.name}</h3>
            <p className="text-sm text-gray-500">{category.description}</p>
          </div>
        </div>

        <div className="flex items-center space-x-4">
          <div className="text-right">
            <p className="font-medium text-gray-900">{category.productCount}</p>
            <p className="text-xs text-gray-500">productos</p>
          </div>
          
          <div className="flex space-x-1">
            <Button
              variant="ghost"
              size="sm"
              onClick={() => handleEditCategory(category)}
            >
              <Edit className="w-4 h-4" />
            </Button>
            <Button variant="ghost" size="sm">
              <Trash2 className="w-4 h-4" />
            </Button>
          </div>
        </div>
      </div>

      {category.children && expandedCategories.has(category.id) && (
        <div className="space-y-2">
          {category.children.map(child => renderCategory(child, level + 1))}
        </div>
      )}
    </div>
  );

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Categorías</h1>
          <p className="text-gray-600 mt-1">Organiza tu inventario por categorías</p>
        </div>
        <Button onClick={handleNewCategory} leftIcon={<Plus className="w-4 h-4" />}>
          Nueva Categoría
        </Button>
      </div>

      {/* Estadísticas */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <Card className="p-4">
          <div className="flex items-center">
            <div className="p-2 bg-blue-100 rounded-lg">
              <Tag className="w-6 h-6 text-blue-600" />
            </div>
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-500">Total Categorías</p>
              <p className="text-2xl font-bold text-gray-900">{categories.length}</p>
            </div>
          </div>
        </Card>
        
        <Card className="p-4">
          <div className="flex items-center">
            <div className="p-2 bg-green-100 rounded-lg">
              <Folder className="w-6 h-6 text-green-600" />
            </div>
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-500">Subcategorías</p>
              <p className="text-2xl font-bold text-gray-900">
                {categories.reduce((acc, cat) => acc + (cat.children?.length || 0), 0)}
              </p>
            </div>
          </div>
        </Card>

        <Card className="p-4">
          <div className="flex items-center">
            <div className="p-2 bg-yellow-100 rounded-lg">
              <Tag className="w-6 h-6 text-yellow-600" />
            </div>
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-500">Más Popular</p>
              <p className="text-lg font-bold text-gray-900">Ropa Femenina</p>
            </div>
          </div>
        </Card>

        <Card className="p-4">
          <div className="flex items-center">
            <div className="p-2 bg-purple-100 rounded-lg">
              <Tag className="w-6 h-6 text-purple-600" />
            </div>
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-500">Total Productos</p>
              <p className="text-2xl font-bold text-gray-900">
                {categories.reduce((acc, cat) => acc + cat.productCount, 0)}
              </p>
            </div>
          </div>
        </Card>
      </div>

      {/* Búsqueda */}
      <Card>
        <CardContent className="p-4">
          <Input
            placeholder="Buscar categorías..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            leftIcon={<Search className="w-4 h-4 text-gray-400" />}
          />
        </CardContent>
      </Card>

      {/* Lista de Categorías */}
      <div className="space-y-4">
        {categories.map(category => renderCategory(category))}
      </div>

      {/* Modal de Categoría */}
      <Modal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        title={selectedCategory ? 'Editar Categoría' : 'Nueva Categoría'}
        size="md"
      >
        <div className="space-y-4">
          <Input label="Nombre de la Categoría" defaultValue={selectedCategory?.name} />
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Descripción
            </label>
            <textarea
              defaultValue={selectedCategory?.description}
              rows={3}
              className="block w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-yellow-500 focus:border-yellow-500"
              placeholder="Descripción de la categoría..."
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Categoría Padre
            </label>
            <select className="block w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-yellow-500 focus:border-yellow-500">
              <option value="">Sin categoría padre</option>
              {categories.map(cat => (
                <option key={cat.id} value={cat.id}>{cat.name}</option>
              ))}
            </select>
          </div>
          
          <div className="flex justify-end space-x-3 pt-6 border-t">
            <Button variant="ghost" onClick={() => setIsModalOpen(false)}>
              Cancelar
            </Button>
            <Button onClick={() => setIsModalOpen(false)}>
              {selectedCategory ? 'Actualizar Categoría' : 'Crear Categoría'}
            </Button>
          </div>
        </div>
      </Modal>
    </div>
  );
}