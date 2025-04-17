<script setup lang="ts">
import Navigation from '@/components/Navigation.vue';
import Devices from '@/components/Devices.vue';
import Measurement from '@/components/Measurement.vue';
import History from '@/components/History.vue';
import DeviceStatus from '@/components/DeviceStatus.vue';
import { DeviceApi } from '@/device/Device';
import { onMounted } from 'vue';
import { ref } from 'vue';
import type { IDevice } from '@/device/IDevice';
import type { ISensorReading } from '@/sensorReading/ISensorReading';
import { SensorReadingApi } from '@/sensorReading/SensorReading';



const devices = ref(<IDevice[]>[])
const sensorReadings = ref(<ISensorReading[]>[])
const newestSensorReading = ref(<ISensorReading>{
    id: 0,
    deviceId: 0,
    airQualityIndex: 0,
    carbondioxide: 0,
    humidity: 0,
    temperature: 0,
    createdAt: new Date()
})
onMounted(() => {
    loadDevices()
    window.setInterval(() => {
        if (currentDeviceId.value != 0) {
            handleChangedevice(currentDeviceId.value)
        } 
    }, 60000)
})
const currentDeviceId = ref(<number>0)

async function loadDevices() {
    const deviceApi = new DeviceApi();

    try {
        const stream = await deviceApi.getDevices();
        devices.value = stream
        console.log(stream);
    } catch (error) {
        console.error('Failed to get devices:', error);
    }
}

async function handleChangedevice(newId: number) {

    const sensorReadingApi = new SensorReadingApi()
    currentDeviceId.value = newId
    try {
        const stream = await sensorReadingApi.getSensorReadingsByDeviceId(newId);
        sensorReadings.value = stream
        console.log(stream)
    } catch (error) {
        console.error('Failed to get SensorReadings:', error)
    }

    if (sensorReadings.value != null) {
        const sortedReadings: ISensorReading[] = sensorReadings.value.sort((a, b) => {
            const dateA: number = new Date(a.createdAt).getTime();
            const dateB: number = new Date(b.createdAt).getTime();
            return dateB - dateA;
        })

        console.log(sortedReadings[0])

        newestSensorReading.value = sortedReadings[0]
    } else {
        newestSensorReading.value = {
            id: 0,
            deviceId: 0,
            airQualityIndex: 0,
            carbondioxide: 0,
            humidity: 0,
            temperature: 0,
            createdAt: new Date()
        };
    }

    console.log('newest ' + newestSensorReading.value.airQualityIndex)

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


</script>

<template>
    <div class="dashboard">
        <Navigation />
        <header>
            <div>
                <Devices :devices="devices" @changeDevice="handleChangedevice" />
            </div>
            <div class="statistics">
                <div class="item-1">
                    <Measurement :title="'Air-Quality-Index'" :value="newestSensorReading.airQualityIndex" :uom="'AQI'"
                        :indicator="'TODO'" :date="formatDate(newestSensorReading.createdAt)" />
                </div>
                <div class="item-2">
                    <Measurement :title="'Temperature'" :value="newestSensorReading.temperature" :uom="'°C'"
                        :indicator="'TODO'" :date="formatDate(newestSensorReading.createdAt)" />
                </div>
                <div class="item-3">
                    <Measurement :title="'Humidity'" :value="newestSensorReading.humidity" :uom="'%'"
                        :indicator="'TODO'" :date="formatDate(newestSensorReading.createdAt)" />
                </div>
                <div class="item-4">
                    <Measurement :title="'Carbondioxide'" :value="newestSensorReading.carbondioxide" :uom="'ppm'"
                        :indicator="'TODO'" :date="formatDate(newestSensorReading.createdAt)" />
                </div>
                <div class="item-5">
                    <History :sensorReadings="sensorReadings" />
                </div>
                <!-- <div class="item-6">
                    <DeviceStatus />
                </div> -->
            </div>
        </header>
    </div>
</template>

<style scoped>
.dashboard {
    display: flex;
    flex-direction: column;
    justify-content: flex-start;
    background: #F9FAFB;
}

header {
    padding: 0px 24px;
}

.statistics {
    display: grid;
    gap: 20px;
    grid-template-columns: 1fr 1fr 1fr 1fr;
    grid-template-rows: 1fr 2fr;
}

.item-1 {
    grid-column-start: 1;
    grid-column-end: 1;
    grid-row-start: 1;
    grid-row-end: 1;
}

.item-2 {
    grid-column-start: 2;
    grid-column-end: 2;
    grid-row-start: 1;
    grid-row-end: 1;
}

.item-3 {
    grid-column-start: 3;
    grid-column-end: 3;
    grid-row-start: 1;
    grid-row-end: 1;
}

.item-4 {
    grid-column-start: 4;
    grid-column-end: 4;
    grid-row-start: 1;
    grid-row-end: 1;
}

.item-5 {
    grid-column-start: 1;
    grid-column-end: 5;
    grid-row-start: 2;
    grid-row-end: 2;
}

.item-6 {
    grid-column-start: 4;
    grid-column-end: 4;
    grid-row-start: 2;
    grid-row-end: 2;
}
</style>