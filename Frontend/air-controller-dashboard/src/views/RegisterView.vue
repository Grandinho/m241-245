<script setup lang="ts">
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { AuthService } from '@/services/AuthService';

const username = ref('');
const password = ref('');
const confirmPassword = ref('');
const isLoading = ref(false);
const errorMessage = ref('');
const successMessage = ref('');
const router = useRouter();

async function handleRegister() {
    if (!username.value || !password.value || !confirmPassword.value) {
        errorMessage.value = 'All fields are required';
        return;
    }

    if (password.value !== confirmPassword.value) {
        errorMessage.value = 'Passwords do not match';
        return;
    }

    if (password.value.length < 6) {
        errorMessage.value = 'Password must be at least 6 characters';
        return;
    }
    try {
        isLoading.value = true;
        errorMessage.value = '';
        successMessage.value = '';

        const response = await AuthService.register({
            username: username.value,
            password: password.value,
        });

        if (response.success) {
            successMessage.value = 'Registration successful! Redirecting to login...';

            username.value = '';
            password.value = '';
            confirmPassword.value = '';

            setTimeout(() => {
                router.push('/login');
            }, 2000);
        } else {
            errorMessage.value = response.message || 'Registration failed';
        }
    } catch (error) {
        console.error('Registration error:', error);
        errorMessage.value = 'Connection error. Please check your network and try again.';
    } finally {
        isLoading.value = false;
    }
}

function goToLogin() {
    router.push('/login');
}
</script>

<template>
    <div class="register-container">
        <div class="register-card">
            <div class="header">
                <h1>Air Controller</h1>
                <p>Create a new account</p>
            </div>

            <form @submit.prevent="handleRegister" class="register-form">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input id="username" v-model="username" type="text" placeholder="Choose a username"
                        autocomplete="username" />
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input id="password" v-model="password" type="password" placeholder="Create a password"
                        autocomplete="new-password" />
                </div>

                <div class="form-group">
                    <label for="confirm-password">Confirm Password</label>
                    <input id="confirm-password" v-model="confirmPassword" type="password"
                        placeholder="Confirm your password" autocomplete="new-password" />
                </div>

                <div v-if="errorMessage" class="error-message">
                    {{ errorMessage }}
                </div>

                <div v-if="successMessage" class="success-message">
                    {{ successMessage }}
                </div>

                <button type="submit" class="register-button" :disabled="isLoading">
                    <span v-if="isLoading">Registering...</span>
                    <span v-else>Register</span>
                </button>

                <div class="login-link">
                    Already have an account? <a href="#" @click.prevent="goToLogin">Login</a>
                </div>
            </form>
        </div>
    </div>
</template>

<style scoped>
.register-container {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    background-color: #F9FAFB;
    padding: 16px;
}

.register-card {
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

.register-form {
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

.error-message {
    padding: 10px;
    background-color: #FEE2E2;
    border-radius: 6px;
    color: #B91C1C;
    font-size: 14px;
}

.success-message {
    padding: 10px;
    background-color: #DCFCE7;
    border-radius: 6px;
    color: #15803D;
    font-size: 14px;
}

.register-button {
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

.register-button:hover {
    background-color: #1D4ED8;
}

.register-button:disabled {
    background-color: #93C5FD;
    cursor: not-allowed;
}

.login-link {
    text-align: center;
    font-size: 14px;
    color: #4B5563;
}

.login-link a {
    color: #2563EB;
    text-decoration: none;
    font-weight: 500;
}

.login-link a:hover {
    text-decoration: underline;
}

@media (max-width: 480px) {
    .register-card {
        padding: 24px;
    }
}
</style>