// Componente Dashboard principal
import React from 'react';
import { 
  DollarSign, 
  Package, 
  Users, 
  TrendingUp, 
  AlertTriangle,
  ShoppingBag,
  Eye,
  Edit
} from 'lucide-react';
import { StatsCard } from './StatsCard';
import { Card, CardHeader, CardTitle, CardContent } from '../ui/Card';
import { Button } from '../ui/Button';

export function Dashboard() {
  // Datos simulados - se conectarán con Spring Boot
  const stats = {
    totalRevenue: 15420,
    totalProducts: 342,
    totalCustomers: 89,
    monthlyGrowth: 12.5,
    lowStockProducts: 8,
    todaySales: 24
  };

  const recentSales = [
    { id: '1', customer: 'María González', amount: 89.50, items: 2, time: '10:30 AM' },
    { id: '2', customer: 'Carlos Ruiz', amount: 156.00, items: 3, time: '11:15 AM' },
    { id: '3', customer: 'Ana López', amount: 67.25, items: 1, time: '12:00 PM' },
    { id: '4', customer: 'José Martínez', amount: 234.75, items: 4, time: '12:45 PM' },
  ];

  const topProducts = [
    { name: 'Blusa Elegante', sales: 45, revenue: 2250 },
    { name: 'Pantalón Casual', sales: 38, revenue: 1900 },
    { name: 'Vestido de Noche', sales: 25, revenue: 2500 },
    { name: 'Camisa Formal', sales: 32, revenue: 1600 },
  ];

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Dashboard</h1>
          <p className="text-gray-600 mt-1">Bienvenido a tu panel de control DPattyModa</p>
        </div>
        <div className="text-right">
          <p className="text-sm text-gray-500">Hoy es</p>
          <p className="font-semibold text-gray-900">
            {new Date().toLocaleDateString('es-PE', { 
              weekday: 'long', 
              year: 'numeric', 
              month: 'long', 
              day: 'numeric' 
            })}
          </p>
        </div>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <StatsCard
          title="Ingresos del Mes"
          value={`S/ ${stats.totalRevenue.toLocaleString()}`}
          change={stats.monthlyGrowth}
          icon={DollarSign}
          color="green"
        />
        <StatsCard
          title="Productos"
          value={stats.totalProducts}
          icon={Package}
          color="blue"
        />
        <StatsCard
          title="Clientes"
          value={stats.totalCustomers}
          change={8.2}
          icon={Users}
          color="purple"
        />
        <StatsCard
          title="Ventas Hoy"
          value={stats.todaySales}
          icon={ShoppingBag}
          color="yellow"
        />
      </div>

      {/* Alertas */}
      {stats.lowStockProducts > 0 && (
        <Card className="border-l-4 border-l-orange-500 bg-orange-50">
          <div className="flex items-center p-4">
            <AlertTriangle className="w-5 h-5 text-orange-500 mr-3" />
            <div className="flex-1">
              <p className="font-medium text-orange-800">
                Productos con Stock Bajo
              </p>
              <p className="text-sm text-orange-700">
                {stats.lowStockProducts} productos necesitan reposición
              </p>
            </div>
            <Button variant="outline" size="sm">
              Ver Productos
            </Button>
            <Button 
              variant="primary" 
              size="sm"
              onClick={() => window.location.hash = '#new-sale'}
            >
              Nueva Venta
            </Button>
          </div>
        </Card>
      )}

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Ventas Recientes */}
        <Card>
          <CardHeader>
            <CardTitle>Ventas Recientes</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {recentSales.map((sale) => (
                <div key={sale.id} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                  <div className="flex-1">
                    <p className="font-medium text-gray-900">{sale.customer}</p>
                    <p className="text-sm text-gray-500">{sale.items} productos • {sale.time}</p>
                  </div>
                  <div className="text-right">
                    <p className="font-bold text-green-600">S/ {sale.amount}</p>
                    <div className="flex space-x-1 mt-1">
                      <Button variant="ghost" size="sm">
                        <Eye className="w-3 h-3" />
                      </Button>
                      <Button variant="ghost" size="sm">
                        <Edit className="w-3 h-3" />
                      </Button>
                    </div>
                  </div>
                </div>
              ))}
            </div>
            <Button variant="outline" className="w-full mt-4">
              Ver Todas las Ventas
            </Button>
            <Button className="w-full mt-2">
              Nueva Venta
            </Button>
          </CardContent>
        </Card>

        {/* Productos Más Vendidos */}
        <Card>
          <CardHeader>
            <CardTitle>Productos Más Vendidos</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {topProducts.map((product, index) => (
                <div key={index} className="flex items-center justify-between">
                  <div className="flex items-center space-x-3">
                    <div className="w-10 h-10 bg-gradient-to-r from-yellow-400 to-yellow-500 rounded-lg flex items-center justify-center text-black font-bold">
                      {index + 1}
                    </div>
                    <div>
                      <p className="font-medium text-gray-900">{product.name}</p>
                      <p className="text-sm text-gray-500">{product.sales} vendidos</p>
                    </div>
                  </div>
                  <div className="text-right">
                    <p className="font-bold text-gray-900">S/ {product.revenue}</p>
                    <div className="w-20 bg-gray-200 rounded-full h-2 mt-1">
                      <div 
                        className="bg-gradient-to-r from-yellow-400 to-yellow-500 h-2 rounded-full" 
                        style={{ width: `${(product.sales / 50) * 100}%` }}
                      ></div>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Gráfico de Tendencias */}
      <Card>
        <CardHeader>
          <div className="flex items-center justify-between">
            <CardTitle>Tendencias de Ventas</CardTitle>
            <div className="flex space-x-2">
              <Button variant="ghost" size="sm">7 días</Button>
              <Button variant="outline" size="sm">30 días</Button>
              <Button variant="ghost" size="sm">90 días</Button>
            </div>
          </div>
        </CardHeader>
        <CardContent>
          <div className="h-64 flex items-center justify-center bg-gradient-to-r from-blue-50 to-indigo-50 rounded-lg">
            <div className="text-center">
              <TrendingUp className="w-12 h-12 text-gray-400 mx-auto mb-2" />
              <p className="text-gray-500">Gráfico de tendencias</p>
              <p className="text-sm text-gray-400">Se integrará con Chart.js</p>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}