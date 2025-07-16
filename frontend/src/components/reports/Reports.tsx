// Módulo de reportes mejorado con gráficos hermosos
import React, { useState } from 'react';
import { Download, Calendar, Filter, TrendingUp, DollarSign, Package, Users, FileText, BarChart3 } from 'lucide-react';
import { Card, CardHeader, CardTitle, CardContent } from '../ui/Card';
import { Button } from '../ui/Button';
import { Input } from '../ui/Input';
import { SalesChart } from '../charts/SalesChart';
import { CustomPieChart } from '../charts/PieChart';
import { CustomBarChart } from '../charts/BarChart';

export function Reports() {
  const [dateRange, setDateRange] = useState('30');
  const [reportType, setReportType] = useState('sales');

  const reportTypes = [
    { id: 'sales', name: 'Reporte de Ventas', icon: DollarSign, color: 'green' },
    { id: 'inventory', name: 'Reporte de Inventario', icon: Package, color: 'blue' },
    { id: 'customers', name: 'Reporte de Clientes', icon: Users, color: 'purple' },
    { id: 'products', name: 'Productos Más Vendidos', icon: TrendingUp, color: 'yellow' },
  ];

  const quickStats = [
    { title: 'Ventas del Mes', value: 'S/ 15,420', change: '+12.5%', positive: true },
    { title: 'Productos Vendidos', value: '342', change: '+8.2%', positive: true },
    { title: 'Nuevos Clientes', value: '23', change: '+15.3%', positive: true },
    { title: 'Ticket Promedio', value: 'S/ 89.50', change: '-2.1%', positive: false },
  ];

  // Datos para gráficos
  const salesData = [
    { date: '2024-01-10', sales: 890, orders: 11 },
    { date: '2024-01-11', sales: 1100, orders: 14 },
    { date: '2024-01-12', sales: 1450, orders: 18 },
    { date: '2024-01-13', sales: 980, orders: 12 },
    { date: '2024-01-14', sales: 1250, orders: 15 },
    { date: '2024-01-15', sales: 1680, orders: 21 },
    { date: '2024-01-16', sales: 1320, orders: 16 },
  ];

  const categoryData = [
    { name: 'Blusas', value: 35, color: '#FFD700' },
    { name: 'Pantalones', value: 28, color: '#FFA500' },
    { name: 'Vestidos', value: 20, color: '#FF8C00' },
    { name: 'Accesorios', value: 12, color: '#FF7F50' },
    { name: 'Calzado', value: 5, color: '#FF6347' },
  ];

  const topProductsData = [
    { name: 'Blusa Elegante', value: 45, color: '#FFD700' },
    { name: 'Pantalón Casual', value: 38, color: '#FFA500' },
    { name: 'Vestido Noche', value: 32, color: '#FF8C00' },
    { name: 'Camisa Formal', value: 28, color: '#FF7F50' },
    { name: 'Falda Moderna', value: 25, color: '#FF6347' },
  ];

  const monthlyRevenueData = [
    { name: 'Ene', value: 12500 },
    { name: 'Feb', value: 15200 },
    { name: 'Mar', value: 18900 },
    { name: 'Abr', value: 16800 },
    { name: 'May', value: 21300 },
    { name: 'Jun', value: 19600 },
  ];

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold bg-gradient-to-r from-gray-900 to-gray-700 bg-clip-text text-transparent">
            📊 Reportes Avanzados
          </h1>
          <p className="text-gray-600 mt-1">Análisis detallado y visualización de datos de DPattyModa</p>
        </div>
        <div className="flex space-x-3">
          <Button variant="outline" leftIcon={<Filter className="w-4 h-4" />}>
            Filtros Avanzados
          </Button>
          <Button leftIcon={<Download className="w-4 h-4" />} className="bg-gradient-to-r from-green-500 to-green-600 hover:from-green-600 hover:to-green-700">
            Exportar Todo
          </Button>
        </div>
      </div>

      {/* Filtros Mejorados */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <Card className="p-4 bg-gradient-to-br from-blue-50 to-indigo-50 border-blue-200">
          <div className="space-y-3">
            <label className="block text-sm font-medium text-blue-800">
              📅 Período de Tiempo
            </label>
            <select
              value={dateRange}
              onChange={(e) => setDateRange(e.target.value)}
              className="block w-full px-3 py-2 border border-blue-300 rounded-lg focus:ring-blue-500 focus:border-blue-500 bg-white"
            >
              <option value="7">Últimos 7 días</option>
              <option value="30">Últimos 30 días</option>
              <option value="90">Últimos 3 meses</option>
              <option value="365">Último año</option>
              <option value="custom">Personalizado</option>
            </select>
          </div>
        </Card>

        <Card className="p-4 bg-gradient-to-br from-green-50 to-emerald-50 border-green-200">
          <div className="space-y-3">
            <label className="block text-sm font-medium text-green-800">
              📅 Fecha Inicio
            </label>
            <Input type="date" className="border-green-300 focus:ring-green-500 focus:border-green-500" />
          </div>
        </Card>

        <Card className="p-4 bg-gradient-to-br from-purple-50 to-violet-50 border-purple-200">
          <div className="space-y-3">
            <label className="block text-sm font-medium text-purple-800">
              📅 Fecha Fin
            </label>
            <Input type="date" className="border-purple-300 focus:ring-purple-500 focus:border-purple-500" />
          </div>
        </Card>

        <Card className="p-4 bg-gradient-to-br from-yellow-50 to-orange-50 border-yellow-200">
          <div className="space-y-3">
            <label className="block text-sm font-medium text-yellow-800">
              📊 Tipo de Reporte
            </label>
            <select
              value={reportType}
              onChange={(e) => setReportType(e.target.value)}
              className="block w-full px-3 py-2 border border-yellow-300 rounded-lg focus:ring-yellow-500 focus:border-yellow-500 bg-white"
            >
              {reportTypes.map(type => (
                <option key={type.id} value={type.id}>{type.name}</option>
              ))}
            </select>
          </div>
        </Card>
      </div>

      {/* Estadísticas Rápidas Mejoradas */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        {quickStats.map((stat, index) => (
          <Card key={index} className="p-6 bg-gradient-to-br from-white to-gray-50 hover:shadow-xl transition-all duration-300 border-l-4 border-l-yellow-400">
            <div className="space-y-2">
              <p className="text-sm font-medium text-gray-500">{stat.title}</p>
              <p className="text-3xl font-bold text-gray-900">{stat.value}</p>
              <p className={`text-sm flex items-center font-medium ${
                stat.positive ? 'text-green-600' : 'text-red-600'
              }`}>
                <span className="mr-1 text-lg">
                  {stat.positive ? '📈' : '📉'}
                </span>
                {stat.change}
              </p>
            </div>
          </Card>
        ))}
      </div>

      {/* Gráficos Principales */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Gráfico de Ventas Diarias */}
        <Card className="bg-gradient-to-br from-white to-blue-50">
          <CardHeader>
            <CardTitle className="flex items-center text-blue-800">
              <TrendingUp className="w-5 h-5 mr-2" />
              📈 Tendencia de Ventas Diarias
            </CardTitle>
          </CardHeader>
          <CardContent>
            <SalesChart data={salesData} type="area" />
          </CardContent>
        </Card>

        {/* Gráfico de Categorías */}
        <Card className="bg-gradient-to-br from-white to-purple-50">
          <CardHeader>
            <CardTitle className="flex items-center text-purple-800">
              <BarChart3 className="w-5 h-5 mr-2" />
              🏷️ Ventas por Categoría
            </CardTitle>
          </CardHeader>
          <CardContent>
            <CustomPieChart data={categoryData} />
          </CardContent>
        </Card>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Productos Más Vendidos */}
        <Card className="bg-gradient-to-br from-white to-green-50">
          <CardHeader>
            <CardTitle className="flex items-center text-green-800">
              <Package className="w-5 h-5 mr-2" />
              🏆 Top Productos
            </CardTitle>
          </CardHeader>
          <CardContent>
            <CustomBarChart data={topProductsData} />
          </CardContent>
        </Card>

        {/* Ingresos Mensuales */}
        <Card className="bg-gradient-to-br from-white to-yellow-50">
          <CardHeader>
            <CardTitle className="flex items-center text-yellow-800">
              <DollarSign className="w-5 h-5 mr-2" />
              💰 Ingresos Mensuales
            </CardTitle>
          </CardHeader>
          <CardContent>
            <CustomBarChart data={monthlyRevenueData} />
          </CardContent>
        </Card>
      </div>

      {/* Tabla de Reporte Detallado Mejorada */}
      <Card className="bg-gradient-to-br from-white to-gray-50">
        <CardHeader>
          <div className="flex items-center justify-between">
            <CardTitle className="flex items-center text-gray-800">
              <FileText className="w-5 h-5 mr-2" />
              📋 Reporte Detallado - Ventas
            </CardTitle>
            <div className="flex space-x-2">
              <Button variant="outline" size="sm" leftIcon={<FileText className="w-4 h-4" />}>
                📄 PDF
              </Button>
              <Button variant="outline" size="sm" leftIcon={<FileText className="w-4 h-4" />}>
                📊 Excel
              </Button>
            </div>
          </div>
        </CardHeader>
        <CardContent className="p-0">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gradient-to-r from-gray-100 to-gray-200">
                <tr>
                  <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">📅 Fecha</th>
                  <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">💰 Ventas</th>
                  <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">📦 Órdenes</th>
                  <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">👥 Clientes</th>
                  <th className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider">📊 Promedio</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200">
                {salesData.map((day, index) => (
                  <tr key={index} className="hover:bg-gradient-to-r hover:from-yellow-50 hover:to-orange-50 transition-all duration-200">
                    <td className="px-6 py-4 whitespace-nowrap text-gray-900 font-medium">
                      {new Date(day.date).toLocaleDateString('es-PE')}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap font-bold text-green-600">
                      S/ {day.sales.toLocaleString()}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-gray-900">
                      {day.orders}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-gray-900">
                      {Math.floor(day.orders * 0.8)}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-gray-900 font-medium">
                      S/ {(day.sales / day.orders).toFixed(2)}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}