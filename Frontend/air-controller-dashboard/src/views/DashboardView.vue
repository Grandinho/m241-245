<script setup lang="ts">
import Navigation from '@/components/Navigation.vue';
</script>

<template>
    <div class="dashboard">
        <Navigation/>
        <div>
            TODO Measurements
        </div>
        <div>
            TODO Historical Data & Device Status
        </div>
    </div>
</template>

<style scoped>
.dashboard {
    display: flex;
    flex-direction: column;
    justify-content: flex-start;
    background: #FFF;    
}

</style>