<script setup lang="ts">
import Navigation from '@/components/Navigation.vue';
import Devices from '@/components/Devices.vue';
import Measurement from '@/components/Measurement.vue';
import { DeviceApi } from '@/device/Device';
import { onMounted } from 'vue';
import { ref } from 'vue';
import type { IDevice } from '@/device/IDevice';
import type { ISensorReading } from '@/sensorReading/ISensorReading';
import { SensorReadingApi } from '@/sensorReading/SensorReading';
import Statistics from '@/components/Statistics.vue';



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
        hour12: true
    };
    const formattingOptions = options || defaultOptions;
    return new Intl.DateTimeFormat(undefined, formattingOptions).format(dateObject);
}


</script>

<template>
    <div class="dashboard">
        <Navigation />
        <header>
            <div class="devices-container">
                <Devices :devices="devices" @changeDevice="handleChangedevice" />
            </div>
            <div class="statistics">
                <div class="measurement-card item-1">
                    <Measurement :title="'Air-Quality-Index'" :value="newestSensorReading.airQualityIndex" :uom="'AQI'"
                        :indicator="'TODO'" :date="formatDate(newestSensorReading.createdAt)" />
                </div>
                <div class="measurement-card item-2">
                    <Measurement :title="'Temperature'" :value="newestSensorReading.temperature" :uom="'°C'"
                        :indicator="'TODO'" :date="formatDate(newestSensorReading.createdAt)" />
                </div>
                <div class="measurement-card item-3">
                    <Measurement :title="'Humidity'" :value="newestSensorReading.humidity" :uom="'%'"
                        :indicator="'TODO'" :date="formatDate(newestSensorReading.createdAt)" />
                </div>
                <div class="measurement-card item-4">
                    <Measurement :title="'Carbondioxide'" :value="newestSensorReading.carbondioxide" :uom="'ppm'"
                        :indicator="'TODO'" :date="formatDate(newestSensorReading.createdAt)" />
                </div>
                <div class="statistics-card item-5">
                    <Statistics :sensorReadings="sensorReadings" dataType="airQualityIndex"
                        title="Air Quality History" />
                </div>
                <div class="statistics-card item-6">
                    <Statistics :sensorReadings="sensorReadings" dataType="temperature" title="Temperature History" />
                </div>
                <div class="statistics-card item-7">
                    <Statistics :sensorReadings="sensorReadings" dataType="humidity" title="Humidity History" />
                </div>
                <div class="statistics-card item-8">
                    <Statistics :sensorReadings="sensorReadings" dataType="carbondioxide" title="CO₂ History" />
                </div>
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
    width: 100%;
    min-height: 100vh;
}

header {
    padding: 16px;
    width: 100%;
    box-sizing: border-box;
}

.devices-container {
    margin-bottom: 20px;
    width: 100%;
}

.statistics {
    display: grid;
    gap: 16px;
    grid-template-columns: repeat(4, 1fr);
    grid-auto-rows: minmax(120px, auto);
}

.measurement-card,
.statistics-card {
    background: white;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
    transition: all 0.3s ease;
    width: 100%;
    height: 100%;
}

@media (max-width: 1200px) {
    .statistics {
        grid-template-columns: repeat(2, 1fr);
    }

    .item-1,
    .item-2,
    .item-3,
    .item-4,
    .item-5,
    .item-6,
    .item-7,
    .item-8 {
        grid-column: auto;
        grid-row: auto;
    }
}

@media (max-width: 768px) {
    .statistics {
        grid-template-columns: 1fr;
        gap: 12px;
    }

    header {
        padding: 12px;
    }

    .measurement-card,
    .statistics-card {
        min-height: 100px;
    }
}

@media (max-width: 480px) {
    header {
        padding: 8px;
    }

    .statistics {
        gap: 10px;
    }
}
</style>