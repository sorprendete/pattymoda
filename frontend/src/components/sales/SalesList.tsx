// Lista de ventas
import React, { useState } from "react";
import { Sale } from "../../types";
import {
  Plus,
  Search,
  Filter,
  Eye,
  Edit,
  DollarSign,
  Calendar,
  CreditCard,
} from "lucide-react";
import { Card, CardHeader, CardTitle, CardContent } from "../ui/Card";
import { Button } from "../ui/Button";
import { Input } from "../ui/Input";

// Elimina la definición local de Sale, ya que ahora se importa desde types

export function SalesList() {
  const [searchTerm, setSearchTerm] = useState("");
  const [filterStatus, setFilterStatus] = useState("all");

  // Obtener ventas desde el backend
  const [sales, setSales] = useState<Sale[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  React.useEffect(() => {
    async function fetchSales() {
      setLoading(true);
      setError(null);
      try {
        // Importa el servicio de ventas
        const { SaleService } = await import("../../services/saleService");
        const response = await SaleService.getAllSales();
        setSales(response.data || []);
      } catch (err: any) {
        setError("Error al cargar ventas");
      } finally {
        setLoading(false);
      }
    }
    fetchSales();
  }, []);

  // Adaptar búsqueda y filtrado usando la estructura real de Sale
  const filteredSales = sales.filter((sale) => {
    // sale.customer es un objeto, por lo que usamos sale.customer.firstName y sale.customer.lastName
    const customerName = `${sale.customer?.firstName ?? ""} ${
      sale.customer?.lastName ?? ""
    }`;
    const matchesSearch =
      customerName.toLowerCase().includes(searchTerm.toLowerCase()) ||
      sale.id.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesFilter =
      filterStatus === "all" || sale.status === filterStatus;
    return matchesSearch && matchesFilter;
  });

  // Usar createdAt para la fecha
  const today = new Date().toISOString().slice(0, 10);
  const todaysSales = sales.filter(
    (sale) => sale.createdAt && sale.createdAt.toString().slice(0, 10) === today
  );
  const todaysTotal = todaysSales.reduce(
    (acc, sale) => acc + (sale.total ?? 0),
    0
  );

  const getStatusBadge = (status: string) => {
    const badges = {
      completed: "bg-green-100 text-green-800",
      pending: "bg-yellow-100 text-yellow-800",
      cancelled: "bg-red-100 text-red-800",
    };
    const labels = {
      completed: "Completado",
      pending: "Pendiente",
      cancelled: "Cancelado",
    };
    return (
      <span
        className={`px-2 py-1 rounded-full text-xs font-medium ${
          badges[status as keyof typeof badges]
        }`}
      >
        {labels[status as keyof typeof labels]}
      </span>
    );
  };

  const getPaymentMethodIcon = (method: string) => {
    switch (method.toLowerCase()) {
      case "efectivo":
        return <DollarSign className="w-4 h-4 text-green-600" />;
      case "tarjeta":
        return <CreditCard className="w-4 h-4 text-blue-600" />;
      default:
        return <CreditCard className="w-4 h-4 text-purple-600" />;
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Ventas</h1>
          <p className="text-gray-600 mt-1">Gestiona todas tus transacciones</p>
        </div>
        <Button leftIcon={<Plus className="w-4 h-4" />}>Nueva Venta</Button>
      </div>

      {/* Resumen del Día */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <Card className="p-4">
          <div className="flex items-center">
            <div className="p-2 bg-green-100 rounded-lg">
              <DollarSign className="w-6 h-6 text-green-600" />
            </div>
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-500">Ventas Hoy</p>
              <p className="text-2xl font-bold text-gray-900">
                S/ {todaysTotal.toFixed(2)}
              </p>
            </div>
          </div>
        </Card>

        <Card className="p-4">
          <div className="flex items-center">
            <div className="p-2 bg-blue-100 rounded-lg">
              <Calendar className="w-6 h-6 text-blue-600" />
            </div>
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-500">Transacciones</p>
              <p className="text-2xl font-bold text-gray-900">
                {todaysSales.length}
              </p>
            </div>
          </div>
        </Card>

        <Card className="p-4">
          <div className="flex items-center">
            <div className="p-2 bg-yellow-100 rounded-lg">
              <DollarSign className="w-6 h-6 text-yellow-600" />
            </div>
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-500">
                Ticket Promedio
              </p>
              <p className="text-2xl font-bold text-gray-900">
                S/{" "}
                {todaysSales.length > 0
                  ? (todaysTotal / todaysSales.length).toFixed(2)
                  : "0.00"}
              </p>
            </div>
          </div>
        </Card>

        <Card className="p-4">
          <div className="flex items-center">
            <div className="p-2 bg-purple-100 rounded-lg">
              <CreditCard className="w-6 h-6 text-purple-600" />
            </div>
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-500">
                Método Popular
              </p>
              <p className="text-lg font-bold text-gray-900">Efectivo</p>
            </div>
          </div>
        </Card>
      </div>

      {/* Filtros */}
      <Card>
        <CardContent className="p-4">
          <div className="flex flex-col sm:flex-row gap-4">
            <div className="flex-1">
              <Input
                placeholder="Buscar por cliente o número de venta..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                leftIcon={<Search className="w-4 h-4 text-gray-400" />}
              />
            </div>
            <div className="flex space-x-2">
              <select
                value={filterStatus}
                onChange={(e) => setFilterStatus(e.target.value)}
                className="px-3 py-2 border border-gray-300 rounded-lg focus:ring-yellow-500 focus:border-yellow-500"
              >
                <option value="all">Todos los estados</option>
                <option value="completed">Completados</option>
                <option value="pending">Pendientes</option>
                <option value="cancelled">Cancelados</option>
              </select>
              <Button
                variant="outline"
                leftIcon={<Filter className="w-4 h-4" />}
              >
                Más Filtros
              </Button>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Lista de Ventas */}
      <Card>
        <CardHeader>
          <CardTitle>Historial de Ventas</CardTitle>
        </CardHeader>
        <CardContent className="p-0">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Venta
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Cliente
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Fecha/Hora
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Items
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Total
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Pago
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Estado
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Acciones
                  </th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {filteredSales.map((sale) => (
                  <tr key={sale.id} className="hover:bg-gray-50">
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="font-medium text-gray-900">{sale.id}</div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="text-gray-900">
                        {sale.customer
                          ? `${sale.customer.firstName} ${sale.customer.lastName}`
                          : ""}
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="text-gray-900">
                        {sale.createdAt
                          ? new Date(sale.createdAt).toLocaleDateString("es-PE")
                          : ""}
                      </div>
                      <div className="text-sm text-gray-500">
                        {sale.createdAt
                          ? new Date(sale.createdAt).toLocaleTimeString("es-PE")
                          : ""}
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="text-gray-900">
                        {sale.items ? sale.items.length : 0} productos
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="font-bold text-gray-900">
                        S/ {sale.total ? sale.total.toFixed(2) : "0.00"}
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex items-center space-x-2">
                        {getPaymentMethodIcon(sale.paymentMethod)}
                        <span className="text-gray-900">
                          {sale.paymentMethod}
                        </span>
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      {getStatusBadge(sale.status)}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                      <div className="flex space-x-2">
                        <Button variant="ghost" size="sm">
                          <Eye className="w-4 h-4" />
                        </Button>
                        <Button variant="ghost" size="sm">
                          <Edit className="w-4 h-4" />
                        </Button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </CardContent>
      </Card>

      {filteredSales.length === 0 && (
        <Card>
          <CardContent className="text-center py-12">
            <DollarSign className="w-12 h-12 text-gray-400 mx-auto mb-4" />
            <h3 className="text-lg font-medium text-gray-900 mb-2">
              No se encontraron ventas
            </h3>
            <p className="text-gray-500 mb-4">
              Ajusta los filtros o crea una nueva venta
            </p>
            <Button>Nueva Venta</Button>
          </CardContent>
        </Card>
      )}
    </div>
  );
}
