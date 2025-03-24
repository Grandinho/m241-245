<script setup lang="ts">
import { DeviceApi } from '@/device/Device';
import Device from './Device.vue';
import { ref } from 'vue';
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



</script>


<template>
    <div class="conn-devices">
        <h2>Connected Devices</h2>
        <div class="devices">
            <Device v-for="device in devices" :key="device.id" :device="device" class="device"
                :class="['device', { 'device-selected': device.id === selectedId }]" @click="switchDevice(device.id)" />
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
    gap: 6px;
}

.devices {
    display: flex;
    align-items: flex-start;
    gap: 16px;
}

.device-selected {
    border: 1px solid #3B82F6;
}
</style>
