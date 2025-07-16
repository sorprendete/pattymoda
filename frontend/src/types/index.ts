// Interfaces y tipos para el sistema DPattyModa
export interface User {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  role: 'ADMIN' | 'EMPLOYEE' | 'CUSTOMER';
  avatar?: string;
  phone?: string;
  address?: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface Product {
  id: string;
  name: string;
  description: string;
  price: number;
  cost: number;
  sku: string;
  category: Category;
  brand: string;
  sizes: Size[];
  colors: Color[];
  images: string[];
  stock: number;
  minStock: number;
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

export interface Category {
  id: string;
  name: string;
  description?: string;
  parentId?: string;
  isActive: boolean;
}

export interface Size {
  id: string;
  name: string;
  order: number;
}

export interface Color {
  id: string;
  name: string;
  hexCode: string;
}

export interface Customer {
  id: string;
  firstName: string;
  lastName: string;
  email: string;
  phone: string;
  address: string;
  district: string;
  city: string;
  totalPurchases: number;
  lastPurchase?: Date;
  preferredPaymentMethod: string;
  createdAt: Date;
}

export interface Sale {
  id: string;
  customer: Customer;
  items: SaleItem[];
  subtotal: number;
  tax: number;
  discount: number;
  total: number;
  paymentMethod: 'CASH' | 'CARD' | 'TRANSFER' | 'YAPE' | 'PLIN';
  status: 'PENDING' | 'COMPLETED' | 'CANCELLED' | 'REFUNDED';
  notes?: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface SaleItem {
  id: string;
  product: Product;
  quantity: number;
  size: string;
  color: string;
  unitPrice: number;
  subtotal: number;
}

export interface DashboardStats {
  totalSales: number;
  totalProducts: number;
  totalCustomers: number;
  monthlyRevenue: number;
  dailySales: number;
  lowStockProducts: number;
  topSellingProducts: Product[];
  recentSales: Sale[];
}

export interface ApiResponse<T> {
  data: T;
  message: string;
  status: number;
  timestamp: Date;
}
// Tipos para configuración de tienda y reportes
export interface StoreConfig {
  id: string;
  name: string;
  address: string;
  logo?: string;
  phone?: string;
  email?: string;
  website?: string;
  facebook?: string;
  instagram?: string;
  schedule?: string;
}

export interface SalesReport {
  totalSales: number;
  totalRevenue: number;
  salesByDate: Array<{ date: string; total: number }>;
  salesByProduct: Array<{ product: string; total: number }>;
  salesByCustomer: Array<{ customer: string; total: number }>;
}

export interface ProductReport {
  topSellingProducts: Product[];
  lowStockProducts: Product[];
  productStats: Array<{ product: string; sold: number }>;
}

export interface CustomerReport {
  topCustomers: Customer[];
  customerStats: Array<{ customer: string; purchases: number }>;
}