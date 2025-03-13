<script setup lang="ts">
import type { IDevice } from '@/device/IDevice';


defineProps<{
    device: IDevice
}>()

</script>

<template>
    <div class="device-content">
        <div class="device-logo-name">
            <img src="../assets/device-icon.svg" alt="" class="device-logo">
            <p class="device-name">{{device.name}}</p>
        </div>
        <p class="device-localization">{{device.localization}}</p>
    </div>
</template>

<style>

    .device {
            display: flex;
            width: 160px;
            height: 50px;
            padding: 17px;
            flex-direction: column;
            justify-content: center;
            align-items: flex-start;
            gap: 8px;
            border-radius: 12px;
            border: 1px solid #E5E7EB;
            background: #FFF;
            box-shadow: 0px 1px 2px 0px rgba(0, 0, 0, 0.05);
        }

    .device:hover {
        border: 1px solid #3B82F6;
    }

    .device-content {
        display: flex;
        flex-direction: column;
        align-content: space-around;
        gap: 8px;
    }

    .device-logo-name {
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .device-logo {
        display: flex;
        height: 20px;
        justify-content: center;
        align-items: center;
    }

    .device-localization {
        display: flex;
        width: 170.047px;
        height: 20px;
        padding: 1px 23.047px 2px 0px;
        align-items: center;
        flex-shrink: 0;
        color: #6B7280;
    }

    p {
        margin: 0px;
    }
</style>