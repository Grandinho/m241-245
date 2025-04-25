/* Devices.vue */
<script setup lang="ts">
import { DeviceApi } from '@/device/Device';
import Device from './Device.vue';
import { ref, onMounted } from 'vue';
import type { IDevice } from '@/device/IDevice';

const props = defineProps<{
    devices: IDevice[]
}>()

const emit = defineEmits<{
    (e: 'changeDevice', newId: number): void
}>()

const selectedId = ref(0)

function switchDevice(id: number) {
    if (selectedId.value == id)
        return;

    console.log(id)
    selectedId.value = id
    emit('changeDevice', id)
}

// Optional: Add scroll buttons functionality
const scrollContainer = ref(null);

</script>

<template>
    <div class="conn-devices">
        <div class="header-row">
            <h2>Connected Devices</h2>  
        </div>
        <div class="devices-container">
            <div class="devices" ref="scrollContainer">
                <Device v-for="device in devices" :key="device.id" :device="device"
                    :class="['device', { 'device-selected': device.id === selectedId }]"
                    @click="switchDevice(device.id)" />
            </div>
        </div>
    </div>
</template>

<style scoped>
.conn-devices {
    display: flex;
    padding-bottom: 25px;
    flex-direction: column;
    justify-content: center;
    align-items: flex-start;
    width: 100%;
}

.header-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
    margin-bottom: 16px;
}

h2 {
    font-size: 1.5rem;
    margin: 0;
}

.scroll-buttons {
    display: flex;
    gap: 8px;
}

.scroll-btn {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    border: 1px solid #E5E7EB;
    background: white;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.2s;
}

.scroll-btn:hover {
    background-color: #F3F4F6;
    border-color: #D1D5DB;
}

.devices-container {
    width: 100%;
    position: relative;
    overflow: hidden;
}

.devices {
    display: flex;
    align-items: flex-start;
    gap: 16px;
    overflow-x: auto;
    width: 100%;
    padding-bottom: 10px;
    /* Space for scrollbar */
    scroll-behavior: smooth;
    -webkit-overflow-scrolling: touch;

    /* Hide scrollbar for Chrome, Safari and Opera */
    &::-webkit-scrollbar {
        height: 4px;
    }

    &::-webkit-scrollbar-track {
        background: #f1f1f1;
        border-radius: 4px;
    }

    &::-webkit-scrollbar-thumb {
        background: #c1c1c1;
        border-radius: 4px;
    }

    &::-webkit-scrollbar-thumb:hover {
        background: #a1a1a1;
    }

    /* Hide scrollbar for IE, Edge and Firefox */
    -ms-overflow-style: none;
    /* IE and Edge */
    scrollbar-width: thin;
    /* Firefox */
}

.device-selected {
    border: 1px solid #3B82F6 !important;
}

/* Responsive styles */
@media screen and (max-width: 768px) {
    .devices {
        gap: 12px;
    }

    h2 {
        font-size: 1.3rem;
    }
}

@media screen and (max-width: 480px) {
    .devices {
        gap: 8px;
    }

    h2 {
        font-size: 1.2rem;
    }

    .conn-devices {
        padding-bottom: 16px;
    }

    .scroll-btn {
        width: 28px;
        height: 28px;
    }
}
</style>

/* CSS for Device.vue (to be added to your existing component) */
<style>
/* Additional styles for Device in horizontal scroll */
.device {
    flex-shrink: 0;
    /* Prevent devices from shrinking */
}

@media screen and (max-width: 768px) {
    .device {
        width: 140px;
    }
}

@media screen and (max-width: 480px) {
    .device {
        width: 130px;
    }
}
</style>