<script setup>
import { DeviceApi } from '@/device/Device';
import Device from './Device.vue';
import { ref } from 'vue';
import { ExitStatus } from 'typescript';

//TODO LOAD Devices from Webservice
const apiClinet = new DeviceApi

const devices = apiClinet.getMovies()

console.log(devices)

const selectedId = ref(0)

function switchDevice(id) {
    if (selectedId.value == id)
        return;

    console.log(id)
    selectedId.value = id
}


</script>


<template>
    <div class="conn-devices">
        <h2>Connected Devices</h2>
        <div class="devices">
            <Device 
                v-for="device in devices" 
                :key="device.id" 
                :device="device" 
                class="device" 
                :class="['device', { 'device-selected': device.id === selectedId }]" 
                @click="switchDevice(device.id)"/>
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
        gap: 18px;
    }

    .devices {
        display: flex;
        height: 102px;
        padding: 0px 741.703px 16px 0px;
        align-items: flex-start;
        gap: 16px;
    }

    .device-selected {
        border: 1px solid #3B82F6;
    }

</style>
