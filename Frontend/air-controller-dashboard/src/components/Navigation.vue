<script setup lang="ts">
import { DeviceApi } from '@/device/Device';
import type { IRequestedDevice } from '@/device/IRequestedDevice';
import { onMounted, onUnmounted, ref } from 'vue';
import CreateDevice from '@/components/CreateDevice.vue';

const showNotification = ref(false)
const showNotificationRef = ref<HTMLElement | null>(null);
const requestedDevices = ref(<IRequestedDevice[]>[])
const selectedDevice = ref(<IRequestedDevice>{})
const acceptNotification = ref(false)

onMounted(() => {
    loadRequestedDevices()
    document.addEventListener("click", handleClickOutside);
})

onUnmounted(() => {
    document.addEventListener("click", handleClickOutside);
});

const handleClickOutside = (event: MouseEvent) => {
    if (showNotificationRef.value && !showNotificationRef.value.contains(event.target as Node)) {
        showNotification.value = false;
    }
};

async function loadRequestedDevices() {
    const deviceApi = new DeviceApi();

    try {
        const stream = await deviceApi.getRequestedDevices();
        requestedDevices.value = stream
        console.log("Requested devices: " + requestedDevices.value);
    } catch (error) {
        console.error('Failed to get devices:', error);
    }
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
        hour12: true // Use 12-hour format with AM/PM
    };
    const formattingOptions = options || defaultOptions;
    return new Intl.DateTimeFormat(undefined, formattingOptions).format(dateObject);
}

function OpenCreateDevice(requestedDevice: IRequestedDevice) {
    acceptNotification.value = true
    selectedDevice.value = requestedDevice
}

function HandleCloseCreation() {
    acceptNotification.value = false
}


async function DeclineDevice(declindedDevice: IRequestedDevice) {
    const deviceApi = new DeviceApi()
    const response = deviceApi.declineDevice(declindedDevice)
    if (response == null) {
        await loadRequestedDevices()
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
            <div class="account">
                <div class="notification-container">
                    <img src="../assets/notification.svg" alt="account" ref="showNotificationRef"
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
                    </div>
                </div>
                <img src="../assets/account-placeholder.jpg" alt="account" class="account-img">
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
}

.notification-img:hover {
    filter: invert(52%) sepia(100%) saturate(6061%) hue-rotate(217deg) brightness(95%) contrast(93%);
}

.account {
    display: flex;
    gap: 20px;
    align-items: center;
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
}

.requested-device {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 350px;
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
}

.accept-img:hover {
    filter: brightness(0) saturate(100%) invert(58%) sepia(40%) saturate(648%) hue-rotate(73deg) brightness(93%) contrast(87%);
}

.delete-img {
    width: 24px;
    height: 24px;
}

.delete-img:hover {
    filter: brightness(0) saturate(100%) invert(32%) sepia(20%) saturate(7222%) hue-rotate(344deg) brightness(106%) contrast(91%);
}
</style>