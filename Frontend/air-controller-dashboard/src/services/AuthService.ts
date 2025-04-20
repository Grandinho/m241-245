import axios, { AxiosError } from 'axios';
import apiClient from './HttpService';

interface LoginCredentials {
    username: string;
    password: string;
}

interface RegisterData {
    username: string;
    password: string;
}

interface AuthResponse {
    token?: string;
    username?: string;
    message?: string;
}

interface LoginResponse {
    success: boolean;
    message?: string;
    user?: {
        username: string;
    };
}

interface RegisterResponse {
    success: boolean;
    message?: string;
}

export class AuthService {
    static async login(credentials: LoginCredentials): Promise<LoginResponse> {
        try {
            const response = await apiClient.post<AuthResponse>(
                "/login",
                credentials,
                {
                    headers: {
                        'Content-Type': 'application/json'
                    }
                }
            );

            const data = response.data;

            if (data.token) {
                localStorage.setItem('token', data.token);
                localStorage.setItem('isAuthenticated', 'true');
                localStorage.setItem('username', credentials.username);

                return {
                    success: true,
                    user: {
                        username: credentials.username
                    }
                };
            } else {
                return {
                    success: false,
                    message: data.message || 'Authentication failed. No token received.'
                };
            }
        } catch (error) {
            let errorMessage = 'Authentication failed.';

            if (axios.isAxiosError(error)) {
                if (error.response) {
                    if (error.response.status === 401) {
                        errorMessage = 'Invalid username or password.';
                    } else if (error.response.status === 429) {
                        errorMessage = 'Too many login attempts. Please try again later.';
                    } else {
                        errorMessage = `Server error: ${error.response.status}`;
                        if (error.response.data && error.response.data.message) {
                            errorMessage += ` - ${error.response.data.message}`;
                        }
                    }
                } else if (error.request) {
                    errorMessage = 'No response from server. Please check your connection.';
                } else {
                    errorMessage = error.message || 'Request failed.';
                }
            }

            console.error('Login error:', error);

            return {
                success: false,
                message: errorMessage
            };
        }
    }

    static async register(userData: RegisterData): Promise<RegisterResponse> {
        try {
            const response = await apiClient.post(
                "/register",
                userData,
                {
                    headers: {
                        'Content-Type': 'application/json'
                    }
                }
            );

            return {
                success: true,
                message: 'Registration successful'
            };
        } catch (error) {
            let errorMessage = 'Registration failed.';

            if (axios.isAxiosError(error)) {
                if (error.response) {
                    if (error.response.status === 409) {
                        errorMessage = 'Username or email already exists.';
                    } else if (error.response.status === 400) {
                        errorMessage = 'Invalid registration data.';
                        if (error.response.data && error.response.data.message) {
                            errorMessage = error.response.data.message;
                        }
                    } else {
                        errorMessage = `Server error: ${error.response.status}`;
                        if (error.response.data && error.response.data.message) {
                            errorMessage = error.response.data.message;
                        }
                    }
                } else if (error.request) {
                    errorMessage = 'No response from server. Please check your connection.';
                } else {
                    errorMessage = error.message || 'Request failed.';
                }
            }

            console.error('Registration error:', error);

            return {
                success: false,
                message: errorMessage
            };
        }
    }

    static logout(): void {
        // try {
        //     await apiClient.post('/logout', {});
        // } catch (error) {
        //     console.error('Logout error:', error);
        // } finally {
        this.clearAuthData();
        // }
    }

    private static clearAuthData(): void {
        localStorage.removeItem('isAuthenticated');
        localStorage.removeItem('username');
        localStorage.removeItem('token');
    }

    static isAuthenticated(): boolean {
        return localStorage.getItem('isAuthenticated') === 'true' &&
            !!localStorage.getItem('token');
    }

    static getCurrentUser(): string | null {
        return localStorage.getItem('username');
    }

    static getAuthToken(): string | null {
        return localStorage.getItem('token');
    }
}