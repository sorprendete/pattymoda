// Componente mejorado para nueva venta con pagos combinados
import React, { useState } from 'react';
import { Plus, Search, Minus, ShoppingCart, User, CreditCard, Calculator, Receipt } from 'lucide-react';
import { Card, CardHeader, CardTitle, CardContent } from '../ui/Card';
import { Button } from '../ui/Button';
import { Input } from '../ui/Input';
import { Modal } from '../ui/Modal';

interface Product {
  id: string;
  name: string;
  price: number;
  stock: number;
  image: string;
}

interface SaleItem {
  product: Product;
  quantity: number;
  size: string;
  color: string;
}

interface PaymentMethod {
  type: string;
  amount: number;
  reference?: string;
}

export function NewSale() {
  const [searchTerm, setSearchTerm] = useState('');
  const [saleItems, setSaleItems] = useState<SaleItem[]>([]);
  const [customer, setCustomer] = useState('');
  const [paymentMethods, setPaymentMethods] = useState<PaymentMethod[]>([
    { type: 'cash', amount: 0 }
  ]);
  const [discount, setDiscount] = useState(0);
  const [isCustomerModalOpen, setIsCustomerModalOpen] = useState(false);

  // Productos simulados
  const products: Product[] = [
    {
      id: '1',
      name: 'Blusa Elegante Manga Larga',
      price: 85.00,
      stock: 15,
      image: 'https://images.pexels.com/photos/1536619/pexels-photo-1536619.jpeg?auto=compress&cs=tinysrgb&w=150&h=150&dpr=2'
    },
    {
      id: '2',
      name: 'Pantalón Casual Denim',
      price: 120.00,
      stock: 8,
      image: 'https://images.pexels.com/photos/1598505/pexels-photo-1598505.jpeg?auto=compress&cs=tinysrgb&w=150&h=150&dpr=2'
    },
    {
      id: '3',
      name: 'Vestido de Noche Elegante',
      price: 180.00,
      stock: 5,
      image: 'https://images.pexels.com/photos/1447884/pexels-photo-1447884.jpeg?auto=compress&cs=tinysrgb&w=150&h=150&dpr=2'
    },
    {
      id: '4',
      name: 'Camisa Formal Blanca',
      price: 95.00,
      stock: 12,
      image: 'https://images.pexels.com/photos/996329/pexels-photo-996329.jpeg?auto=compress&cs=tinysrgb&w=150&h=150&dpr=2'
    }
  ];

  const filteredProducts = products.filter(product =>
    product.name.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const addToSale = (product: Product) => {
    const existingItem = saleItems.find(item => item.product.id === product.id);
    if (existingItem) {
      setSaleItems(saleItems.map(item =>
        item.product.id === product.id
          ? { ...item, quantity: item.quantity + 1 }
          : item
      ));
    } else {
      setSaleItems([...saleItems, {
        product,
        quantity: 1,
        size: 'M',
        color: 'Negro'
      }]);
    }
  };

  const updateQuantity = (productId: string, newQuantity: number) => {
    if (newQuantity === 0) {
      setSaleItems(saleItems.filter(item => item.product.id !== productId));
    } else {
      setSaleItems(saleItems.map(item =>
        item.product.id === productId
          ? { ...item, quantity: newQuantity }
          : item
      ));
    }
  };

  const addPaymentMethod = () => {
    setPaymentMethods([...paymentMethods, { type: 'cash', amount: 0 }]);
  };

  const updatePaymentMethod = (index: number, field: string, value: any) => {
    const updated = paymentMethods.map((method, i) => 
      i === index ? { ...method, [field]: value } : method
    );
    setPaymentMethods(updated);
  };

  const removePaymentMethod = (index: number) => {
    if (paymentMethods.length > 1) {
      setPaymentMethods(paymentMethods.filter((_, i) => i !== index));
    }
  };

  const subtotal = saleItems.reduce((acc, item) => acc + (item.product.price * item.quantity), 0);
  const discountAmount = (subtotal * discount) / 100;
  const afterDiscount = subtotal - discountAmount;
  const tax = afterDiscount * 0.18;
  const total = afterDiscount + tax;
  const totalPaid = paymentMethods.reduce((acc, method) => acc + method.amount, 0);
  const change = totalPaid - total;

  const paymentMethodOptions = [
    { value: 'cash', label: '💵 Efectivo', icon: '💵' },
    { value: 'card', label: '💳 Tarjeta', icon: '💳' },
    { value: 'yape', label: '📱 Yape', icon: '📱' },
    { value: 'plin', label: '📲 Plin', icon: '📲' },
    { value: 'transfer', label: '🏦 Transferencia', icon: '🏦' },
  ];

  const handleCompleteSale = () => {
    if (totalPaid < total) {
      alert('El monto pagado es insuficiente');
      return;
    }

    console.log('Venta completada:', {
      customer,
      items: saleItems,
      paymentMethods,
      subtotal,
      discount: discountAmount,
      tax,
      total,
      totalPaid,
      change
    });
    
    // Limpiar formulario
    setSaleItems([]);
    setCustomer('');
    setPaymentMethods([{ type: 'cash', amount: 0 }]);
    setDiscount(0);
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold bg-gradient-to-r from-green-600 to-blue-600 bg-clip-text text-transparent">
            🛒 Nueva Venta
          </h1>
          <p className="text-gray-600 mt-1">Procesa una nueva transacción de DPattyModa</p>
        </div>
        <div className="flex space-x-3">
          <Button variant="outline" leftIcon={<Receipt className="w-4 h-4" />}>
            📋 Borrador
          </Button>
          <Button variant="outline" leftIcon={<Calculator className="w-4 h-4" />}>
            🧮 Calculadora
          </Button>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Productos */}
        <div className="lg:col-span-2 space-y-6">
          <Card className="bg-gradient-to-br from-blue-50 to-indigo-50 border-blue-200">
            <CardHeader>
              <CardTitle className="flex items-center text-blue-800">
                <ShoppingCart className="w-5 h-5 mr-2" />
                🛍️ Seleccionar Productos
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                <Input
                  placeholder="🔍 Buscar productos por nombre, código..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  leftIcon={<Search className="w-4 h-4 text-gray-400" />}
                  className="bg-white border-blue-300 focus:ring-blue-500 focus:border-blue-500"
                />
                
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4 max-h-96 overflow-y-auto">
                  {filteredProducts.map((product) => (
                    <div
                      key={product.id}
                      className="flex items-center space-x-3 p-4 bg-white border-2 border-gray-200 rounded-xl hover:border-blue-400 hover:shadow-lg cursor-pointer transition-all duration-200"
                      onClick={() => addToSale(product)}
                    >
                      <img
                        src={product.image}
                        alt={product.name}
                        className="w-16 h-16 object-cover rounded-lg shadow-md"
                      />
                      <div className="flex-1">
                        <h4 className="font-bold text-gray-900">{product.name}</h4>
                        <p className="text-sm text-gray-500">📦 Stock: {product.stock}</p>
                        <p className="text-lg font-bold text-green-600">S/ {product.price}</p>
                      </div>
                      <Button size="sm" className="bg-gradient-to-r from-green-500 to-blue-500 hover:from-green-600 hover:to-blue-600">
                        <Plus className="w-4 h-4" />
                      </Button>
                    </div>
                  ))}
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Panel Derecho */}
        <div className="space-y-6">
          {/* Cliente */}
          <Card className="bg-gradient-to-br from-purple-50 to-pink-50 border-purple-200">
            <CardHeader>
              <CardTitle className="flex items-center text-purple-800">
                <User className="w-5 h-5 mr-2" />
                👤 Cliente
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                <Input
                  placeholder="🔍 Buscar cliente..."
                  value={customer}
                  onChange={(e) => setCustomer(e.target.value)}
                  className="bg-white border-purple-300 focus:ring-purple-500 focus:border-purple-500"
                />
                <Button
                  variant="outline"
                  size="sm"
                  className="w-full border-purple-300 text-purple-700 hover:bg-purple-100"
                  onClick={() => setIsCustomerModalOpen(true)}
                >
                  ➕ Nuevo Cliente
                </Button>
              </div>
            </CardContent>
          </Card>

          {/* Carrito */}
          <Card className="bg-gradient-to-br from-green-50 to-emerald-50 border-green-200">
            <CardHeader>
              <CardTitle className="flex items-center text-green-800">
                <ShoppingCart className="w-5 h-5 mr-2" />
                🛒 Carrito ({saleItems.length})
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-3 max-h-64 overflow-y-auto">
                {saleItems.map((item) => (
                  <div key={item.product.id} className="flex items-center space-x-2 p-3 bg-white rounded-lg shadow-sm border border-green-200">
                    <img
                      src={item.product.image}
                      alt={item.product.name}
                      className="w-10 h-10 object-cover rounded-lg"
                    />
                    <div className="flex-1 min-w-0">
                      <p className="text-sm font-bold text-gray-900 truncate">
                        {item.product.name}
                      </p>
                      <p className="text-xs text-gray-500">
                        S/ {item.product.price} c/u
                      </p>
                    </div>
                    <div className="flex items-center space-x-1">
                      <Button
                        size="sm"
                        variant="ghost"
                        onClick={() => updateQuantity(item.product.id, item.quantity - 1)}
                        className="w-8 h-8 p-0"
                      >
                        <Minus className="w-3 h-3" />
                      </Button>
                      <span className="text-sm font-bold w-8 text-center bg-gray-100 rounded px-2 py-1">
                        {item.quantity}
                      </span>
                      <Button
                        size="sm"
                        variant="ghost"
                        onClick={() => updateQuantity(item.product.id, item.quantity + 1)}
                        className="w-8 h-8 p-0"
                      >
                        <Plus className="w-3 h-3" />
                      </Button>
                    </div>
                  </div>
                ))}
                
                {saleItems.length === 0 && (
                  <div className="text-center py-8 text-gray-500">
                    <ShoppingCart className="w-12 h-12 mx-auto mb-2 opacity-50" />
                    <p className="text-sm">🛒 Carrito vacío</p>
                    <p className="text-xs">Agrega productos para comenzar</p>
                  </div>
                )}
              </div>
            </CardContent>
          </Card>

          {/* Descuento */}
          <Card className="bg-gradient-to-br from-yellow-50 to-orange-50 border-yellow-200">
            <CardHeader>
              <CardTitle className="flex items-center text-yellow-800">
                🏷️ Descuento
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="flex items-center space-x-2">
                <Input
                  type="number"
                  placeholder="0"
                  value={discount}
                  onChange={(e) => setDiscount(Number(e.target.value))}
                  className="bg-white border-yellow-300 focus:ring-yellow-500 focus:border-yellow-500"
                />
                <span className="text-yellow-800 font-bold">%</span>
              </div>
              {discount > 0 && (
                <p className="text-sm text-yellow-700 mt-2">
                  💰 Descuento: S/ {discountAmount.toFixed(2)}
                </p>
              )}
            </CardContent>
          </Card>

          {/* Resumen */}
          <Card className="bg-gradient-to-br from-gray-50 to-slate-100 border-gray-300">
            <CardHeader>
              <CardTitle className="text-gray-800">📊 Resumen de Venta</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                <div className="flex justify-between">
                  <span>Subtotal:</span>
                  <span className="font-bold">S/ {subtotal.toFixed(2)}</span>
                </div>
                {discount > 0 && (
                  <div className="flex justify-between text-yellow-600">
                    <span>Descuento ({discount}%):</span>
                    <span className="font-bold">-S/ {discountAmount.toFixed(2)}</span>
                  </div>
                )}
                <div className="flex justify-between">
                  <span>IGV (18%):</span>
                  <span className="font-bold">S/ {tax.toFixed(2)}</span>
                </div>
                <div className="border-t pt-3">
                  <div className="flex justify-between font-bold text-xl text-green-600">
                    <span>💰 Total:</span>
                    <span>S/ {total.toFixed(2)}</span>
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Métodos de Pago Combinados */}
          <Card className="bg-gradient-to-br from-indigo-50 to-blue-50 border-indigo-200">
            <CardHeader>
              <CardTitle className="flex items-center justify-between text-indigo-800">
                <div className="flex items-center">
                  <CreditCard className="w-5 h-5 mr-2" />
                  💳 Métodos de Pago
                </div>
                <Button
                  size="sm"
                  variant="outline"
                  onClick={addPaymentMethod}
                  className="border-indigo-300 text-indigo-700 hover:bg-indigo-100"
                >
                  <Plus className="w-4 h-4" />
                </Button>
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                {paymentMethods.map((method, index) => (
                  <div key={index} className="p-3 bg-white rounded-lg border border-indigo-200">
                    <div className="flex items-center justify-between mb-2">
                      <select
                        value={method.type}
                        onChange={(e) => updatePaymentMethod(index, 'type', e.target.value)}
                        className="flex-1 px-2 py-1 border border-indigo-300 rounded focus:ring-indigo-500 focus:border-indigo-500 text-sm"
                      >
                        {paymentMethodOptions.map((option) => (
                          <option key={option.value} value={option.value}>
                            {option.label}
                          </option>
                        ))}
                      </select>
                      {paymentMethods.length > 1 && (
                        <Button
                          size="sm"
                          variant="ghost"
                          onClick={() => removePaymentMethod(index)}
                          className="ml-2 text-red-500 hover:text-red-700"
                        >
                          <Minus className="w-4 h-4" />
                        </Button>
                      )}
                    </div>
                    <Input
                      type="number"
                      step="0.01"
                      placeholder="0.00"
                      value={method.amount}
                      onChange={(e) => updatePaymentMethod(index, 'amount', Number(e.target.value))}
                      className="border-indigo-300 focus:ring-indigo-500 focus:border-indigo-500"
                    />
                    {['yape', 'plin', 'transfer'].includes(method.type) && (
                      <Input
                        placeholder="Número de referencia"
                        value={method.reference || ''}
                        onChange={(e) => updatePaymentMethod(index, 'reference', e.target.value)}
                        className="mt-2 border-indigo-300 focus:ring-indigo-500 focus:border-indigo-500"
                      />
                    )}
                  </div>
                ))}
                
                <div className="bg-white p-3 rounded-lg border-2 border-indigo-300">
                  <div className="flex justify-between mb-2">
                    <span className="font-medium">💰 Total a Pagar:</span>
                    <span className="font-bold text-green-600">S/ {total.toFixed(2)}</span>
                  </div>
                  <div className="flex justify-between mb-2">
                    <span className="font-medium">💵 Total Pagado:</span>
                    <span className="font-bold text-blue-600">S/ {totalPaid.toFixed(2)}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="font-medium">🔄 Vuelto:</span>
                    <span className={`font-bold ${change >= 0 ? 'text-green-600' : 'text-red-600'}`}>
                      S/ {change.toFixed(2)}
                    </span>
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Botones de Acción */}
          <div className="space-y-3">
            <Button
              className="w-full bg-gradient-to-r from-green-500 to-blue-500 hover:from-green-600 hover:to-blue-600"
              size="lg"
              onClick={handleCompleteSale}
              disabled={saleItems.length === 0 || totalPaid < total}
            >
              ✅ Completar Venta
            </Button>
            <Button variant="outline" className="w-full border-gray-300 text-gray-700 hover:bg-gray-100">
              💾 Guardar Borrador
            </Button>
          </div>
        </div>
      </div>

      {/* Modal Nuevo Cliente */}
      <Modal
        isOpen={isCustomerModalOpen}
        onClose={() => setIsCustomerModalOpen(false)}
        title="👤 Nuevo Cliente"
        size="md"
      >
        <div className="space-y-4">
          <div className="grid grid-cols-2 gap-4">
            <Input label="Nombre" placeholder="Nombre del cliente" />
            <Input label="Apellido" placeholder="Apellido del cliente" />
          </div>
          <Input label="Email" type="email" placeholder="cliente@email.com" />
          <Input label="Teléfono" placeholder="+51 999 999 999" />
          <Input label="Dirección" placeholder="Dirección completa" />
          
          <div className="flex justify-end space-x-3 pt-6 border-t">
            <Button variant="ghost" onClick={() => setIsCustomerModalOpen(false)}>
              Cancelar
            </Button>
            <Button onClick={() => setIsCustomerModalOpen(false)} className="bg-gradient-to-r from-purple-500 to-pink-500">
              ✅ Crear Cliente
            </Button>
          </div>
        </div>
      </Modal>
    </div>
  );
}