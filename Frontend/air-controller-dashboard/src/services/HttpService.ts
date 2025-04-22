import axios, { AxiosError } from 'axios';
import { AuthService } from './AuthService';

const apiClient = axios.create({
    // baseURL: '/api',
    baseURL: 'http://172.18.14.27:8080',
    headers: {
        'Content-Type': 'application/json'
    }
});

apiClient.interceptors.request.use(
    (config) => {
        const token = AuthService.getAuthToken();
        if (token && config.headers) {
            config.headers['Authorization'] = `Bearer ${token}`;
        }
        return config;
    },
    (error) => {
        return Promise.reject(error);
    }
);

export default apiClient