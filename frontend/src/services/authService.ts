// Servicio de autenticación conectado al backend
import { apiService } from './api';
import { User, ApiResponse } from '../types';

interface LoginRequest {
  email: string;
  password: string;
}

interface LoginResponse {
  token: string;
  type: string;
  id: number;
  nombre: string;
  email: string;
  rol: string;
}

export class AuthService {
  static async login(credentials: LoginRequest): Promise<ApiResponse<LoginResponse>> {
    const response = await apiService.post<LoginResponse>('/auth/login', credentials);
    
    // Guardar token en localStorage
    if (response.data && response.data.token) {
      localStorage.setItem('authToken', response.data.token);
      localStorage.setItem('user', JSON.stringify({
        id: response.data.id.toString(),
        email: response.data.email,
        firstName: response.data.nombre.split(' ')[0],
        lastName: response.data.nombre.split(' ').slice(1).join(' ') || '',
        role: response.data.rol,
        createdAt: new Date(),
        updatedAt: new Date(),
      }));
    }
    
    return response;
  }

  static async register(userData: {
    nombre: string;
    email: string;
    password: string;
    rol?: string;
  }): Promise<ApiResponse<string>> {
    return apiService.post<string>('/auth/register', userData);
  }

  static logout(): void {
    localStorage.removeItem('authToken');
    localStorage.removeItem('user');
  }

  static getCurrentUser(): User | null {
    const userStr = localStorage.getItem('user');
    if (userStr) {
      try {
        return JSON.parse(userStr);
      } catch (error) {
        console.error('Error parsing user from localStorage:', error);
        return null;
      }
    }
    return null;
  }

  static getToken(): string | null {
    return localStorage.getItem('authToken');
  }

  static isAuthenticated(): boolean {
    return !!this.getToken();
  }
}