<script setup lang="ts">
import Navigation from '@/components/Navigation.vue';
import Devices from '@/components/Devices.vue';
import Measurement from '@/components/Measurement.vue';
import History from '@/components/History.vue';
import DeviceStatus from '@/components/DeviceStatus.vue';
</script>

<template>
    <div class="dashboard">
        <Navigation />
        <header>
            <div>
                <Devices />
            </div>
            <div class="statistics">
                <div class="item-1">
                    <Measurement />
                </div>
                <div class="item-2">
                    <Measurement />
                </div>
                <div class="item-3">
                    <Measurement />
                </div>
                <div class="item-4">
                    <Measurement />
                </div>
                <div class="item-5">
                    <History />
                </div>
                <div class="item-6">
                    <DeviceStatus />
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
}

header {
    padding: 12px 24px;
}

.statistics {
    display: grid;
    gap: 20px;
    grid-template-columns: 1fr 1fr 1fr 1fr;
    grid-template-rows: 1fr 1.5fr;
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
    grid-column-end: 4;
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