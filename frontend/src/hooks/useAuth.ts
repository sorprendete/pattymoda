// Hook de autenticación
import { useState, useEffect, createContext, useContext } from 'react';
import { User } from '../types';
import { useLocalStorage } from './useLocalStorage';

interface AuthContextType {
  user: User | null;
  login: (email: string, password: string) => Promise<void>;
  logout: () => void;
  isLoading: boolean;
  isAuthenticated: boolean;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}

export function useAuthState() {
  const [user, setUser] = useLocalStorage<User | null>('user', null);
  const [isLoading, setIsLoading] = useState(false);

  const login = async (email: string, password: string) => {
    setIsLoading(true);
    try {
      // Simulación de login - conectar con Spring Boot
      const mockUser: User = {
        id: '1',
        email,
        firstName: 'Admin',
        lastName: 'DPattyModa',
        role: 'ADMIN',
        avatar: 'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=100&h=100&dpr=2',
        phone: '+51 965 123 456',
        address: 'Pampa Hermosa, Loreto, Perú',
        createdAt: new Date(),
        updatedAt: new Date(),
      };
      
      setTimeout(() => {
        setUser(mockUser);
        localStorage.setItem('authToken', 'mock-jwt-token');
        setIsLoading(false);
      }, 1000);
    } catch (error) {
      setIsLoading(false);
      throw error;
    }
  };

  const logout = () => {
    setUser(null);
    localStorage.removeItem('authToken');
  };

  return {
    user,
    login,
    logout,
    isLoading,
    isAuthenticated: !!user,
  };
}