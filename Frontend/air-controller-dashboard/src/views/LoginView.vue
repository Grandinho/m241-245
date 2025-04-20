<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { AuthService } from '@/services/AuthService';

const username = ref('');
const password = ref('');
const rememberMe = ref(false);
const isLoading = ref(false);
const errorMessage = ref('');
const router = useRouter();

async function handleLogin() {
    if (!username.value || !password.value) {
        errorMessage.value = 'Username and password are required';
        return;
    }

    try {
        isLoading.value = true;
        errorMessage.value = '';

        const response = await AuthService.login({
            username: username.value,
            password: password.value
        });

        if (response.success) {
            if (rememberMe.value) {
                localStorage.setItem('rememberedUser', username.value);
            } else {
                localStorage.removeItem('rememberedUser');
            }

            router.push('/dashboard');
        } else {
            errorMessage.value = response.message || 'Authentication failed';
        }
    } catch (error) {
        console.error('Login error:', error);
        errorMessage.value = 'Connection error. Please check your network and try again.';
    } finally {
        isLoading.value = false;
    }
}

function goToRegister() {
    router.push('/register');
}

function goToDashboard() {
    router.push('/dashboard');
}

onMounted(() => {
    const rememberedUser = localStorage.getItem('rememberedUser');
    if (rememberedUser) {
        username.value = rememberedUser;
        rememberMe.value = true;
    }
});
</script>

<template>
    <div class="login-container">
        <div class="login-card">
            <div class="header">
                <h1>Air Controller</h1>
                <p>Login to your account</p>
            </div>

            <form @submit.prevent="handleLogin" class="login-form">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input id="username" v-model="username" type="text" placeholder="Enter your username"
                        autocomplete="username" />
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input id="password" v-model="password" type="password" placeholder="Enter your password"
                        autocomplete="current-password" />
                </div>

                <div class="options-row">
                    <div class="remember-me">
                        <input id="remember" type="checkbox" v-model="rememberMe" />
                        <label for="remember">Remember me</label>
                    </div>
                    <a @click.prevent="goToDashboard" class="forward-dashboard">Go to Dashboard</a>
                </div>

                <div v-if="errorMessage" class="error-message">
                    {{ errorMessage }}
                </div>

                <button type="submit" class="login-button" :disabled="isLoading">
                    <span v-if="isLoading">Logging in...</span>
                    <span v-else>Login</span>
                </button>

                <div class="register-link">
                    Don't have an account? <a href="#" @click.prevent="goToRegister">Register</a>
                </div>
            </form>
        </div>
    </div>
</template>

<style scoped>
.login-container {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    background-color: #F9FAFB;
    padding: 16px;
}

.login-card {
    width: 100%;
    max-width: 420px;
    padding: 32px;
    background-color: #FFFFFF;
    border-radius: 8px;
    box-shadow: 0px 1px 3px rgba(0, 0, 0, 0.1);
}

.header {
    margin-bottom: 32px;
    text-align: center;
}

.header h1 {
    font-size: 24px;
    font-weight: 600;
    color: #111827;
    margin-bottom: 8px;
}

.header p {
    font-size: 16px;
    color: #6B7280;
}

.login-form {
    display: flex;
    flex-direction: column;
    gap: 24px;
}

.form-group {
    display: flex;
    flex-direction: column;
    gap: 8px;
}

.form-group label {
    font-size: 14px;
    font-weight: 500;
    color: #374151;
}

.form-group input {
    padding: 10px 12px;
    border: 1px solid #E5E7EB;
    border-radius: 6px;
    font-size: 14px;
    transition: border-color 0.2s;
}

.form-group input:focus {
    outline: none;
    border-color: #2563EB;
    box-shadow: 0 0 0 1px rgba(37, 99, 235, 0.2);
}

.form-group input::placeholder {
    color: #9CA3AF;
}

.options-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.remember-me {
    display: flex;
    align-items: center;
    gap: 8px;
}

.remember-me input[type="checkbox"] {
    width: 16px;
    height: 16px;
    accent-color: #2563EB;
}

.remember-me label {
    font-size: 14px;
    color: #4B5563;
}

.forward-dashboard {
    font-size: 14px;
    color: #2563EB;
    text-decoration: none;
    cursor: pointer;
}

.forward-dashboard:hover {
    text-decoration: underline;
}

.error-message {
    padding: 10px;
    background-color: #FEE2E2;
    border-radius: 6px;
    color: #B91C1C;
    font-size: 14px;
}

.login-button {
    background-color: #2563EB;
    color: white;
    border: none;
    border-radius: 6px;
    padding: 12px 16px;
    font-size: 16px;
    font-weight: 500;
    cursor: pointer;
    transition: background-color 0.2s;
}

.login-button:hover {
    background-color: #1D4ED8;
}

.login-button:disabled {
    background-color: #93C5FD;
    cursor: not-allowed;
}

.register-link {
    text-align: center;
    font-size: 14px;
    color: #4B5563;
}

.register-link a {
    color: #2563EB;
    text-decoration: none;
    font-weight: 500;
}

.register-link a:hover {
    text-decoration: underline;
}

@media (max-width: 480px) {
    .login-card {
        padding: 24px;
    }

    .options-row {
        flex-direction: column;
        align-items: flex-start;
        gap: 12px;
    }
}
</style>