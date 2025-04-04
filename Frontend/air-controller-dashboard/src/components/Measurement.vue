<script setup lang="ts">

const props = defineProps<{
    title: string;
    value: number;
    uom: string
    indicator: string
}>()

</script>

<template>
    <div class="measuremnt">
        <div class="header">
            <div class="title">{{ title }}</div>
            <button class="options">
                <img src="../assets/options.png" alt="" class="options-img">
            </button>
        </div>
        <div class="content">
            <div class="value-content">
                <div class="value">{{ value }} {{ uom }}</div>
                <div class="indicator">{{ indicator }}</div>
            </div>
        </div>
    </div>

</template>

<style scoped>
.measuremnt {
    border-radius: 0.5rem;
    border: 0px solid #E5E7EB;
    background: #FFF;
    box-shadow: 0px 1px 2px 0px rgba(0, 0, 0, 0.05);
    display: flex;
    flex-direction: column;
    padding: 16px 24px;
}

.header {
    display: flex;
    justify-content: space-between;
    padding-bottom: 12px;
}

.content {
    display: flex;
    padding: 70px 0px;
    justify-content: center;
    align-items: center;
    border-radius: 12px;
    border: 0px solid #E5E7EB;
    background: radial-gradient(circle, #DCFCE7 0%, rgba(249, 250, 251, 100) 100%);
}

button {
    border: 0px solid #E5E7EB;
    /* filter: brightness(0) saturate(100%) invert(32%) sepia(20%) saturate(7222%) hue-rotate(344deg) brightness(106%) contrast(91%); */
    background: rgba(0, 0, 0, 0.00);
}



.options-img:hover {
    filter: invert(52%) sepia(100%) saturate(6061%) hue-rotate(217deg) brightness(95%) contrast(93%);
    cursor: pointer;
}


.value-content {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
}

.value {
    color: #22C55E;
    text-align: center;
    font-size: 36px;
    font-style: normal;
    font-weight: 700;
    line-height: normal;
}

.indicator {
    color: #4B5563;
    text-align: center;
    font-size: 14px;
    font-style: normal;
    font-weight: 400;
    line-height: normal;
}

.title {
    color: #000;
    font-size: 16px;
    font-style: normal;
    font-weight: 600;
    line-height: 16px;
    /* 100% */
}
</style>