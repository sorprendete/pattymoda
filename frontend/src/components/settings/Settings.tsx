// Módulo de configuración
import React, { useState } from 'react';
import { Save, Store, User, Bell, Shield, Palette, Database, Printer } from 'lucide-react';
import { Card, CardHeader, CardTitle, CardContent } from '../ui/Card';
import { Button } from '../ui/Button';
import { Input } from '../ui/Input';

export function Settings() {
  const [activeTab, setActiveTab] = useState('business');
  const [businessData, setBusinessData] = useState({
    name: 'DPattyModa',
    address: 'Pampa Hermosa, Loreto, Perú',
    phone: '+51 965 123 456',
    email: 'info@dpattymoda.com',
    ruc: '20123456789',
    description: 'Tienda de ropa moderna y elegante',
  });

  const settingsTabs = [
    { id: 'business', name: 'Negocio', icon: Store },
    { id: 'profile', name: 'Perfil', icon: User },
    { id: 'notifications', name: 'Notificaciones', icon: Bell },
    { id: 'security', name: 'Seguridad', icon: Shield },
    { id: 'appearance', name: 'Apariencia', icon: Palette },
    { id: 'data', name: 'Datos', icon: Database },
    { id: 'printing', name: 'Impresión', icon: Printer },
  ];

  const renderBusinessSettings = () => (
    <div className="space-y-6">
      <Card>
        <CardHeader>
          <CardTitle>Información del Negocio</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <Input
              label="Nombre del Negocio"
              value={businessData.name}
              onChange={(e) => setBusinessData({...businessData, name: e.target.value})}
            />
            <Input
              label="RUC"
              value={businessData.ruc}
              onChange={(e) => setBusinessData({...businessData, ruc: e.target.value})}
            />
          </div>
          
          <Input
            label="Dirección"
            value={businessData.address}
            onChange={(e) => setBusinessData({...businessData, address: e.target.value})}
          />
          
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <Input
              label="Teléfono"
              value={businessData.phone}
              onChange={(e) => setBusinessData({...businessData, phone: e.target.value})}
            />
            <Input
              label="Email"
              type="email"
              value={businessData.email}
              onChange={(e) => setBusinessData({...businessData, email: e.target.value})}
            />
          </div>
          
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Descripción
            </label>
            <textarea
              value={businessData.description}
              onChange={(e) => setBusinessData({...businessData, description: e.target.value})}
              rows={3}
              className="block w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-yellow-500 focus:border-yellow-500"
            />
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Configuración de Impuestos</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <Input label="IGV (%)" defaultValue="18" type="number" />
            <Input label="Moneda" defaultValue="PEN" />
          </div>
          
          <div className="flex items-center space-x-2">
            <input type="checkbox" id="includeIgv" className="rounded" defaultChecked />
            <label htmlFor="includeIgv" className="text-sm text-gray-700">
              Incluir IGV en precios mostrados
            </label>
          </div>
        </CardContent>
      </Card>
    </div>
  );

  const renderProfileSettings = () => (
    <div className="space-y-6">
      <Card>
        <CardHeader>
          <CardTitle>Información Personal</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="flex items-center space-x-6">
            <div className="w-20 h-20 bg-gradient-to-r from-yellow-400 to-yellow-500 rounded-full flex items-center justify-center text-black font-bold text-2xl">
              A
            </div>
            <div>
              <Button variant="outline" size="sm">Cambiar Foto</Button>
              <p className="text-xs text-gray-500 mt-1">JPG, PNG hasta 2MB</p>
            </div>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <Input label="Nombre" defaultValue="Admin" />
            <Input label="Apellido" defaultValue="DPattyModa" />
          </div>
          
          <Input label="Email" type="email" defaultValue="admin@dpattymoda.com" />
          <Input label="Teléfono" defaultValue="+51 965 123 456" />
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Cambiar Contraseña</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <Input label="Contraseña Actual" type="password" />
          <Input label="Nueva Contraseña" type="password" />
          <Input label="Confirmar Contraseña" type="password" />
        </CardContent>
      </Card>
    </div>
  );

  const renderNotificationSettings = () => (
    <div className="space-y-6">
      <Card>
        <CardHeader>
          <CardTitle>Notificaciones del Sistema</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          {[
            { id: 'lowStock', label: 'Stock bajo', description: 'Cuando un producto tenga stock menor al mínimo' },
            { id: 'newSale', label: 'Nueva venta', description: 'Notificar cuando se registre una nueva venta' },
            { id: 'newCustomer', label: 'Nuevo cliente', description: 'Cuando se registre un nuevo cliente' },
            { id: 'dailyReport', label: 'Reporte diario', description: 'Resumen diario de ventas y métricas' },
          ].map((notification) => (
            <div key={notification.id} className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
              <div>
                <h4 className="font-medium text-gray-900">{notification.label}</h4>
                <p className="text-sm text-gray-500">{notification.description}</p>
              </div>
              <input type="checkbox" className="rounded" defaultChecked />
            </div>
          ))}
        </CardContent>
      </Card>
    </div>
  );

  const renderSecuritySettings = () => (
    <div className="space-y-6">
      <Card>
        <CardHeader>
          <CardTitle>Configuración de Seguridad</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
            <div>
              <h4 className="font-medium text-gray-900">Autenticación de dos factores</h4>
              <p className="text-sm text-gray-500">Añade una capa extra de seguridad</p>
            </div>
            <Button variant="outline" size="sm">Configurar</Button>
          </div>
          
          <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
            <div>
              <h4 className="font-medium text-gray-900">Sesiones activas</h4>
              <p className="text-sm text-gray-500">Gestiona tus sesiones activas</p>
            </div>
            <Button variant="outline" size="sm">Ver Sesiones</Button>
          </div>
          
          <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
            <div>
              <h4 className="font-medium text-gray-900">Backup automático</h4>
              <p className="text-sm text-gray-500">Respaldo automático de datos</p>
            </div>
            <input type="checkbox" className="rounded" defaultChecked />
          </div>
        </CardContent>
      </Card>
    </div>
  );

  const renderAppearanceSettings = () => (
    <div className="space-y-6">
      <Card>
        <CardHeader>
          <CardTitle>Personalización</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Tema
            </label>
            <div className="grid grid-cols-3 gap-3">
              {['Claro', 'Oscuro', 'Automático'].map((theme) => (
                <button
                  key={theme}
                  className="p-3 border-2 border-gray-300 rounded-lg hover:border-yellow-500 transition-colors"
                >
                  {theme}
                </button>
              ))}
            </div>
          </div>
          
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Color Principal
            </label>
            <div className="flex space-x-2">
              {['#FFD700', '#3B82F6', '#10B981', '#F59E0B', '#EF4444'].map((color) => (
                <button
                  key={color}
                  className="w-8 h-8 rounded-full border-2 border-gray-300"
                  style={{ backgroundColor: color }}
                />
              ))}
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  );

  const renderContent = () => {
    switch (activeTab) {
      case 'business': return renderBusinessSettings();
      case 'profile': return renderProfileSettings();
      case 'notifications': return renderNotificationSettings();
      case 'security': return renderSecuritySettings();
      case 'appearance': return renderAppearanceSettings();
      default: return renderBusinessSettings();
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Configuración</h1>
          <p className="text-gray-600 mt-1">Personaliza tu sistema DPattyModa</p>
        </div>
        <Button leftIcon={<Save className="w-4 h-4" />}>
          Guardar Cambios
        </Button>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-4 gap-6">
        {/* Sidebar de Configuración */}
        <Card className="lg:col-span-1">
          <CardContent className="p-4">
            <nav className="space-y-2">
              {settingsTabs.map((tab) => {
                const Icon = tab.icon;
                return (
                  <button
                    key={tab.id}
                    onClick={() => setActiveTab(tab.id)}
                    className={`w-full flex items-center space-x-3 px-3 py-2 rounded-lg transition-colors ${
                      activeTab === tab.id
                        ? 'bg-gradient-to-r from-yellow-400 to-yellow-500 text-black'
                        : 'text-gray-700 hover:bg-gray-100'
                    }`}
                  >
                    <Icon className="w-5 h-5" />
                    <span className="font-medium">{tab.name}</span>
                  </button>
                );
              })}
            </nav>
          </CardContent>
        </Card>

        {/* Contenido de Configuración */}
        <div className="lg:col-span-3">
          {renderContent()}
        </div>
      </div>
    </div>
  );
}