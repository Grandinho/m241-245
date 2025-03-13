<script setup lang="ts">
import Navigation from '@/components/Navigation.vue';
import Devices from '@/components/Devices.vue';
</script>

<template>
    <div class="dashboard">
        <Navigation/>
        <header>
            <div>
                <Devices/>
            </div>
            <div class="statistics">
                <div class="item-1">
                    Air Quality Index
                </div>
                <div class="item-2">
                    CO2 Levels
                </div>
                <div class="item-3">
                    Temperature
                </div>
                <div class="item-4">
                    Historical Data
                </div>
                <div class="item-5">
                    Device Status
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
    background: #FFF;    
}

header {
    padding: 12px 24px;
}

.statistics {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;
    grid-template-rows: 1fr 1fr;
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
    grid-column-start: 1;
    grid-column-end: 2;
    grid-row-start: 2;
    grid-row-end: 2;
}

.item-5 {
    grid-column-start: 3;
    grid-column-end: 3;
    grid-row-start: 2;
    grid-row-end: 2;
}

</style>