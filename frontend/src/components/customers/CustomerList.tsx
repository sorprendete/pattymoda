// Lista de clientes
import React, { useState } from "react";
import {
  Plus,
  Search,
  Edit,
  Trash2,
  Users,
  Phone,
  Mail,
  MapPin,
} from "lucide-react";
import { Card, CardHeader, CardTitle, CardContent } from "../ui/Card";
import { Button } from "../ui/Button";
import { Input } from "../ui/Input";
import { Modal } from "../ui/Modal";

interface Customer {
  id: string;
  firstName: string;
  lastName: string;
  email: string;
  phone: string;
  address: string;
  totalPurchases: number;
  lastPurchase: string;
  status: "active" | "inactive";
}

export function CustomerList() {
  const [searchTerm, setSearchTerm] = useState("");
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [selectedCustomer, setSelectedCustomer] = useState<Customer | null>(
    null
  );

  // Elimina cualquier array de clientes mock, solo usa datos del backend...
  const customers: Customer[] = [
    {
      id: "1",
      firstName: "María",
      lastName: "González",
      email: "maria.gonzalez@email.com",
      phone: "+51 987 654 321",
      address: "Jr. Los Tulipanes 123, Pampa Hermosa",
      totalPurchases: 1250.0,
      lastPurchase: "2024-01-15",
      status: "active",
    },
    {
      id: "2",
      firstName: "Carlos",
      lastName: "Ruiz",
      email: "carlos.ruiz@email.com",
      phone: "+51 998 765 432",
      address: "Av. Principal 456, Loreto",
      totalPurchases: 890.5,
      lastPurchase: "2024-01-10",
      status: "active",
    },
    {
      id: "3",
      firstName: "Ana",
      lastName: "López",
      email: "ana.lopez@email.com",
      phone: "+51 976 543 210",
      address: "Calle Las Flores 789, Pampa Hermosa",
      totalPurchases: 2100.75,
      lastPurchase: "2024-01-12",
      status: "active",
    },
    {
      id: "4",
      firstName: "José",
      lastName: "Martínez",
      email: "jose.martinez@email.com",
      phone: "+51 965 432 109",
      address: "Jr. Comercio 321, Loreto",
      totalPurchases: 567.25,
      lastPurchase: "2024-01-08",
      status: "active",
    },
  ];

  const filteredCustomers = customers.filter(
    (customer) =>
      `${customer.firstName} ${customer.lastName}`
        .toLowerCase()
        .includes(searchTerm.toLowerCase()) ||
      customer.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
      customer.phone.includes(searchTerm)
  );

  const handleEditCustomer = (customer: Customer) => {
    setSelectedCustomer(customer);
    setIsModalOpen(true);
  };

  const handleNewCustomer = () => {
    setSelectedCustomer(null);
    setIsModalOpen(true);
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Clientes</h1>
          <p className="text-gray-600 mt-1">Gestiona tu base de clientes</p>
        </div>
        <Button
          onClick={handleNewCustomer}
          leftIcon={<Plus className="w-4 h-4" />}
        >
          Nuevo Cliente
        </Button>
      </div>

      {/* Estadísticas Rápidas */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <Card className="p-4">
          <div className="flex items-center">
            <div className="p-2 bg-blue-100 rounded-lg">
              <Users className="w-6 h-6 text-blue-600" />
            </div>
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-500">
                Total Clientes
              </p>
              <p className="text-2xl font-bold text-gray-900">
                {customers.length}
              </p>
            </div>
          </div>
        </Card>

        <Card className="p-4">
          <div className="flex items-center">
            <div className="p-2 bg-green-100 rounded-lg">
              <Users className="w-6 h-6 text-green-600" />
            </div>
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-500">
                Clientes Activos
              </p>
              <p className="text-2xl font-bold text-gray-900">
                {customers.filter((c) => c.status === "active").length}
              </p>
            </div>
          </div>
        </Card>

        <Card className="p-4">
          <div className="flex items-center">
            <div className="p-2 bg-yellow-100 rounded-lg">
              <Users className="w-6 h-6 text-yellow-600" />
            </div>
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-500">
                Promedio Compras
              </p>
              <p className="text-2xl font-bold text-gray-900">
                S/{" "}
                {(
                  customers.reduce((acc, c) => acc + c.totalPurchases, 0) /
                  customers.length
                ).toFixed(0)}
              </p>
            </div>
          </div>
        </Card>

        <Card className="p-4">
          <div className="flex items-center">
            <div className="p-2 bg-purple-100 rounded-lg">
              <Users className="w-6 h-6 text-purple-600" />
            </div>
            <div className="ml-4">
              <p className="text-sm font-medium text-gray-500">Cliente VIP</p>
              <p className="text-lg font-bold text-gray-900">Ana López</p>
            </div>
          </div>
        </Card>
      </div>

      {/* Búsqueda */}
      <Card>
        <CardContent className="p-4">
          <Input
            placeholder="Buscar clientes por nombre, email o teléfono..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            leftIcon={<Search className="w-4 h-4 text-gray-400" />}
          />
        </CardContent>
      </Card>

      {/* Lista de Clientes */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {filteredCustomers.map((customer) => (
          <Card
            key={customer.id}
            className="hover:shadow-lg transition-shadow duration-200"
          >
            <CardContent className="p-6">
              <div className="flex items-start justify-between mb-4">
                <div className="flex items-center space-x-3">
                  <div className="w-12 h-12 bg-gradient-to-r from-yellow-400 to-yellow-500 rounded-full flex items-center justify-center text-black font-bold">
                    {customer.firstName.charAt(0)}
                    {customer.lastName.charAt(0)}
                  </div>
                  <div>
                    <h3 className="font-semibold text-gray-900">
                      {customer.firstName} {customer.lastName}
                    </h3>
                    <p className="text-sm text-gray-500">
                      Cliente desde{" "}
                      {new Date(customer.lastPurchase).getFullYear()}
                    </p>
                  </div>
                </div>
                <div className="flex space-x-1">
                  <Button
                    variant="ghost"
                    size="sm"
                    onClick={() => handleEditCustomer(customer)}
                  >
                    <Edit className="w-4 h-4" />
                  </Button>
                  <Button variant="ghost" size="sm">
                    <Trash2 className="w-4 h-4" />
                  </Button>
                </div>
              </div>

              <div className="space-y-3">
                <div className="flex items-center space-x-2 text-sm text-gray-600">
                  <Mail className="w-4 h-4" />
                  <span>{customer.email}</span>
                </div>

                <div className="flex items-center space-x-2 text-sm text-gray-600">
                  <Phone className="w-4 h-4" />
                  <span>{customer.phone}</span>
                </div>

                <div className="flex items-center space-x-2 text-sm text-gray-600">
                  <MapPin className="w-4 h-4" />
                  <span className="line-clamp-1">{customer.address}</span>
                </div>
              </div>

              <div className="mt-4 pt-4 border-t border-gray-100">
                <div className="flex justify-between items-center">
                  <div>
                    <p className="text-sm text-gray-500">Total Compras</p>
                    <p className="font-bold text-green-600">
                      S/ {customer.totalPurchases.toLocaleString()}
                    </p>
                  </div>
                  <div className="text-right">
                    <p className="text-sm text-gray-500">Última Compra</p>
                    <p className="text-sm font-medium text-gray-900">
                      {new Date(customer.lastPurchase).toLocaleDateString(
                        "es-PE"
                      )}
                    </p>
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      {filteredCustomers.length === 0 && (
        <Card>
          <CardContent className="text-center py-12">
            <Users className="w-12 h-12 text-gray-400 mx-auto mb-4" />
            <h3 className="text-lg font-medium text-gray-900 mb-2">
              No se encontraron clientes
            </h3>
            <p className="text-gray-500 mb-4">
              Prueba con otros términos de búsqueda
            </p>
            <Button onClick={handleNewCustomer}>Agregar Primer Cliente</Button>
          </CardContent>
        </Card>
      )}

      {/* Modal de Cliente */}
      <Modal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        title={selectedCustomer ? "Editar Cliente" : "Nuevo Cliente"}
        size="lg"
      >
        <div className="space-y-4">
          <div className="grid grid-cols-2 gap-4">
            <Input label="Nombre" defaultValue={selectedCustomer?.firstName} />
            <Input label="Apellido" defaultValue={selectedCustomer?.lastName} />
          </div>
          <Input
            label="Email"
            type="email"
            defaultValue={selectedCustomer?.email}
          />
          <Input label="Teléfono" defaultValue={selectedCustomer?.phone} />
          <Input label="Dirección" defaultValue={selectedCustomer?.address} />

          <div className="flex justify-end space-x-3 pt-6 border-t">
            <Button variant="ghost" onClick={() => setIsModalOpen(false)}>
              Cancelar
            </Button>
            <Button onClick={() => setIsModalOpen(false)}>
              {selectedCustomer ? "Actualizar Cliente" : "Crear Cliente"}
            </Button>
          </div>
        </div>
      </Modal>
    </div>
  );
}
