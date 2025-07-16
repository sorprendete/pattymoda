// Hook de autenticación actualizado
import { useState, useEffect } from 'react';
import { User } from '../types';
import { AuthService } from '../services/authService';

export function useAuthState() {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    // Verificar si hay un usuario logueado al cargar
    const currentUser = AuthService.getCurrentUser();
    if (currentUser) {
      setUser(currentUser);
    }
  }, []);

  const login = async (email: string, password: string) => {
    setIsLoading(true);
    try {
      const response = await AuthService.login({ email, password });
      
      if (response.data) {
        const userData: User = {
          id: response.data.id.toString(),
          email: response.data.email,
          firstName: response.data.nombre.split(' ')[0],
          lastName: response.data.nombre.split(' ').slice(1).join(' ') || '',
          role: response.data.rol as 'ADMIN' | 'EMPLOYEE' | 'CUSTOMER',
          createdAt: new Date(),
          updatedAt: new Date(),
        };
        setUser(userData);
      }
    } catch (error: any) {
      console.error('Login error:', error);
      throw new Error(error.message || 'Error al iniciar sesión');
    } finally {
      setIsLoading(false);
    }
  };

  const logout = () => {
    AuthService.logout();
    setUser(null);
  };

  return {
    user,
    login,
    logout,
    isLoading,
    isAuthenticated: !!user,
  };
}