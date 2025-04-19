<script setup lang="ts">
import type { IDevice } from '@/device/IDevice';
import { onMounted, ref } from 'vue';
import Device from './Device.vue';
import { DeviceApi } from '@/device/Device';


const device = ref(<IDevice>{})


const emit = defineEmits<{
    (e: 'close'): void
}>()

const props = defineProps<
    {
        macAddress: string;
    }>()


onMounted(() => {
    device.value.macAddress = props.macAddress
})

function close() {
    emit('close')
}

async function handleSubmit() {
    const deviceApi = new DeviceApi()
    const respone = await deviceApi.createDevice(device.value)
    if (respone == null) {
        close()
        window.location.reload()
    } else {
        // TODO implement error handling
    }
}

</script>

<template>
    <div class="container">
        <div class="form-container">
            <h3 class="form-title">Add New Device</h3>
            <form class="form" v-on:submit.prevent="handleSubmit()">
                <div class="form-item">
                    <label for="macAddress" class="form-label">MAC-Address</label>
                    <input type="text" id="macAddress" name="macAddress" class="form-input"
                        placeholder="Enter device MAC-Address..." v-model="device.macAddress" disabled>
                </div>
                <div class="form-item">
                    <label for="name" class="form-label">Name</label>
                    <input type="text" id="name" name="name" class="form-input" placeholder="Enter device Name..."
                        v-model="device.name">
                </div>
                <div class="form-item">
                    <label for="localization" class="form-label">Localization</label>
                    <input type="text" id="localization" name="localization" class="form-input"
                        placeholder="Enter device localization..." v-model="device.localization">
                </div>
                <div class="buttons">
                    <button type="submit" class="form-button">Add device</button>
                    <button type="button" class="form-button cancel-button" @click="close()">Cancel</button>
                </div>
            </form>
        </div>
    </div>
</template>

<style scoped>
.container {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    z-index: 1000;
    display: flex;
    justify-content: center;
    align-items: center;
    overflow: auto;
}

.form-container {
    position: relative;
    width: 90%;
    max-width: 450px;
    background-color: #F9FAFB;
    box-shadow: 0px 4px 16px rgba(0, 0, 0, 0.15);
    border-radius: 10px;
    padding: 24px;
    margin: 16px;
    max-height: 90vh;
    overflow-y: auto;
}

.form-title {
    text-align: center;
    margin-top: 0;
    margin-bottom: 24px;
    color: #1F2937;
    font-size: 1.25rem;
}

.form {
    display: flex;
    flex-direction: column;
    width: 100%;
    gap: 16px;
}

.buttons {
    display: flex;
    justify-content: space-between;
    margin-top: 24px;
    width: 100%;
    gap: 12px;
}

.form-button {
    flex: 1;
    padding: 10px 16px;
    border: none;
    border-radius: 6px;
    background-color: #2563EB;
    color: white;
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    transition: background-color 0.2s, transform 0.1s;
}

.form-button:hover {
    background-color: #1D4ED8;
}

.form-button:active {
    transform: translateY(1px);
}

.cancel-button {
    background-color: #F3F4F6;
    color: #4B5563;
    border: 1px solid #D1D5DB;
}

.cancel-button:hover {
    background-color: #E5E7EB;
    color: #1F2937;
}

.form-item {
    display: flex;
    flex-direction: column;
    gap: 6px;
    width: 100%;
}

.form-label {
    font-size: 14px;
    font-weight: 500;
    color: #4B5563;
}

.form-input {
    padding: 10px 12px;
    border: 1px solid #D1D5DB;
    border-radius: 6px;
    font-size: 14px;
    transition: border-color 0.2s, box-shadow 0.2s;
    background-color: white;
}

.form-input:focus {
    outline: none;
    border-color: #2563EB;
    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
}

.form-input:disabled {
    background-color: #F3F4F6;
    cursor: not-allowed;
}

.form-input::placeholder {
    color: #9CA3AF;
}

/* Responsive adjustments */
@media (max-width: 640px) {
    .form-container {
        width: 95%;
        padding: 16px;
    }

    .form-title {
        font-size: 1.125rem;
        margin-bottom: 16px;
    }

    .buttons {
        flex-direction: column;
    }

    .form-button {
        width: 100%;
    }
}

@media (min-width: 641px) and (max-width: 1024px) {
    .form-container {
        width: 80%;
        max-width: 500px;
    }
}

@media (min-height: 600px) {
    .form-container {
        max-height: 450px;
    }
}

@media (max-height: 599px) {
    .form-container {
        max-height: 90vh;
    }
}
</style>