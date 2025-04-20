<script setup lang="ts">
import { ref, onMounted, onUnmounted, computed } from 'vue';
import { useRouter } from 'vue-router';
import { AuthService } from '@/services/AuthService';
import { DeviceApi } from '@/device/Device';
import type { IRequestedDevice } from '@/device/IRequestedDevice';
import CreateDevice from '@/components/CreateDevice.vue';

const router = useRouter();
const username = computed(() => AuthService.getCurrentUser() || 'User');
const isAuthenticated = computed(() => AuthService.isAuthenticated());

const showNotification = ref(false);
const showNotificationRef = ref<HTMLElement | null>(null);
const requestedDevices = ref(<IRequestedDevice[]>[]);
const selectedDevice = ref(<IRequestedDevice>{});
const acceptNotification = ref(false);

onMounted(() => {
    console.log(isAuthenticated.value)
    if (isAuthenticated.value) {
        loadRequestedDevices();
    }
    document.addEventListener("click", handleClickOutside);
});

onUnmounted(() => {
    document.removeEventListener("click", handleClickOutside);
});

const handleClickOutside = (event: MouseEvent) => {
    if (showNotificationRef.value && !showNotificationRef.value.contains(event.target as Node)) {
        showNotification.value = false;
    }
};

async function loadRequestedDevices() {
    if (!isAuthenticated.value) return;

    const deviceApi = new DeviceApi();
    try {
        const stream = await deviceApi.getRequestedDevices();
        requestedDevices.value = stream;
        console.log("Requested devices: ", requestedDevices.value);
    } catch (error) {
        console.error('Failed to get devices:', error);
    }
}

async function handleLogin() {
    router.push('/login');
}

function handleLogout() {
    AuthService.logout();
    router.push('/login');
}

function formatDate(date: Date | string, options?: Intl.DateTimeFormatOptions) {
    const dateObject = date instanceof Date ? date : new Date(date);
    if (isNaN(dateObject.getTime())) {
        console.error('Invalid date:', date);
        return 'Invalid date';
    }

    const defaultOptions: Intl.DateTimeFormatOptions = {
        year: "2-digit",
        month: "2-digit",
        day: "2-digit",
        hour: "2-digit",
        minute: "2-digit",
        hour12: true
    };
    const formattingOptions = options || defaultOptions;
    return new Intl.DateTimeFormat(undefined, formattingOptions).format(dateObject);
}

function OpenCreateDevice(requestedDevice: IRequestedDevice) {
    acceptNotification.value = true;
    selectedDevice.value = requestedDevice;
}

function HandleCloseCreation() {
    acceptNotification.value = false;
}

async function DeclineDevice(declindedDevice: IRequestedDevice) {
    const deviceApi = new DeviceApi();
    const response = await deviceApi.declineDevice(declindedDevice);
    if (response == null) {
        await loadRequestedDevices();
    } else {
        // TODO implement error handling
    }
}
</script>

<template>
    <nav>
        <div class="navbar">
            <div class="logo">
                <img src="../assets/logo.svg" alt="logo" class="logo-img">
                <h3>IoT Dashboard</h3>
            </div>

            <div v-if="isAuthenticated" class="account">
                <div class="notification-container">
                    <img src="../assets/notification.svg" alt="notification" ref="showNotificationRef"
                        class="notification-img" @click="showNotification = !showNotification">
                    <div class="notification-menu" v-if="showNotification">
                        <div v-for="requestedDevice in requestedDevices" :key="requestedDevice.id">
                            <div class="requested-device">
                                <img src="../assets/iot.png" alt="iot" class="iot-img">
                                <div>
                                    <p class="request-device-text">Device {{ requestedDevice.macAddress }} requests
                                        connection to the IoT-Dashboard. Permit?</p>
                                    <p class="request-device-time">{{ formatDate(requestedDevice.createdAt) }}</p>
                                </div>
                                <div class="permit">
                                    <img src="../assets/accept.png" alt="accept" class="accept-img"
                                        v-on:click="OpenCreateDevice(requestedDevice)">
                                    <img src="../assets/delete.png" alt="delete" class="delete-img"
                                        v-on:click="DeclineDevice(requestedDevice)">
                                </div>
                            </div>
                        </div>
                        <div v-if="requestedDevices.length === 0" class="no-notifications">
                            No pending device requests
                        </div>
                    </div>
                </div>
                <div class="user-profile">
                    <div class="user-dropdown">
                        <button @click="handleLogout" class="logout-button">Logout</button>
                    </div>
                </div>
            </div>

            <div v-else class="login-container">
                <button @click="handleLogin" class="login-button">Login</button>
            </div>
        </div>
    </nav>
    <CreateDevice v-if="acceptNotification" :macAddress="selectedDevice.macAddress" @close="HandleCloseCreation()" />
</template>

<style scoped>
nav {
    display: flex;
    padding: 0px 24px;
    padding-bottom: 1px;
    justify-content: center;
    align-items: center;
    flex-shrink: 0;
    border-bottom: 1px solid #E5E7EB;
    background: #FFF;
    height: 50px;
}

.navbar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    height: 50px;
    width: 100%;
}

.logo {
    display: flex;
    align-items: center;
    gap: 12px;
}

.logo-img {
    width: 24px;
    height: 24px;
}

.account {
    display: flex;
    gap: 10px;
    align-items: center;
}

.user-profile {
    display: flex;
    align-items: center;
    position: relative;
    cursor: pointer;
}



.user-dropdown {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-left: 8px;
}

.username {
    font-size: 14px;
    font-weight: 500;
    color: #111827;
}

.account-img {
    width: 32px;
    height: 32px;
    flex-shrink: 0;
    border-radius: 9999px;
    border: 0px solid #E5E7EB;
}

.notification-img {
    width: 14px;
    height: 16px;
    flex-shrink: 0;
    border-radius: 9999px;
    border: 0px solid #E5E7EB;
    cursor: pointer;
}

.notification-img:hover {
    filter: invert(52%) sepia(100%) saturate(6061%) hue-rotate(217deg) brightness(95%) contrast(93%);
}

.notification-container {
    position: relative;
}

.notification-menu {
    position: absolute;
    background: white;
    border: 1px solid #E5E7EB;
    border-radius: 4px;
    margin-top: 10px;
    margin-right: 10px;
    box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
    z-index: 10;
    right: 0;
    min-width: 350px;
}

.requested-device {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 95%;
    padding: 10px 10px 10px 5px;
    border-bottom: 1px solid #E5E7EB;
    gap: 5px;
}

.request-device-text {
    font-size: 12px;
}

.request-device-time {
    font-size: 10px;
    color: gray;
}

.permit {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 5px;
}

.iot-img {
    width: 24px;
    height: 24px;
    filter: invert(52%) sepia(100%) saturate(6061%) hue-rotate(217deg) brightness(95%) contrast(93%);
}

.accept-img {
    width: 24px;
    height: 24px;
    cursor: pointer;
}

.accept-img:hover {
    filter: brightness(0) saturate(100%) invert(58%) sepia(40%) saturate(648%) hue-rotate(73deg) brightness(93%) contrast(87%);
}

.delete-img {
    width: 24px;
    height: 24px;
    cursor: pointer;
}

.delete-img:hover {
    filter: brightness(0) saturate(100%) invert(32%) sepia(20%) saturate(7222%) hue-rotate(344deg) brightness(106%) contrast(91%);
}

.no-notifications {
    padding: 15px;
    text-align: center;
    color: #6B7280;
    font-size: 14px;
}

/* Login button styles */
.login-container {
    display: flex;
    align-items: center;
}

.login-button {
    background-color: #2563EB;
    color: white;
    border: none;
    border-radius: 6px;
    padding: 8px 16px;
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    transition: background-color 0.2s;
}

.login-button:hover {
    background-color: #1D4ED8;
}

.logout-button {
    background-color: transparent;
    color: #EF4444;
    border: 1px solid #EF4444;
    border-radius: 6px;
    padding: 4px 10px;
    font-size: 12px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s;
}

.logout-button:hover {
    background-color: #FEE2E2;
}
</style>