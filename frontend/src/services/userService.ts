// Servicio de usuarios
import { apiService } from './api';
import { User, ApiResponse } from '../types';

export class UserService {
  static async getAllUsers(): Promise<ApiResponse<User[]>> {
    return apiService.get<User[]>('/users');
  }

  static async getUserById(id: string): Promise<ApiResponse<User>> {
    return apiService.get<User>(`/users/${id}`);
  }

  static async createUser(user: Omit<User, 'id'>): Promise<ApiResponse<User>> {
    return apiService.post<User>('/users', user);
  }

  static async updateUser(id: string, user: Partial<User>): Promise<ApiResponse<User>> {
    return apiService.put<User>(`/users/${id}`, user);
  }

  static async deleteUser(id: string): Promise<ApiResponse<void>> {
    return apiService.delete<void>(`/users/${id}`);
  }
}
