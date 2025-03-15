<script setup lang="ts">

</script>

<template>
    <div class="history">
        <div class="header">
            <div class="title">Historical Data</div>
            <div class="filters">
                <button class="filter">Day</button>
                <button class="filter">Week</button>
                <button class="filter">Month</button>
            </div>
        </div>
        <div class="content">

        </div>
    </div>
</template>

<style scoped>
.history {
    display: flex;
    padding: 24px;
    flex-direction: column;
    align-items: flex-start;
    gap: 16px;
    background: #FFF;
    box-shadow: 0px 1px 2px 0px rgba(0, 0, 0, 0.05);
    border-radius: 8px;
    border: 0px solid #E5E7EB;
    height: 100%;
}

.header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
}

.content {
    border-radius: 8px;
    border: 0px solid #E5E7EB;
    background: #F9FAFB;
    height: 300px;
    width: 100%;
}

.title {
    color: #000;
    font-size: 16px;
    font-style: normal;
    font-weight: 600;
    line-height: 16px;
}

.filters {
    display: flex;
    justify-content: start;
    align-items: center;
    gap: 8px;
}

.filter {
    display: flex;
    padding: 5px 11.641px 6px 12px;
    justify-content: center;
    align-items: center;
    flex-shrink: 0;
    border-radius: 9999px;
    border: 0px solid #E5E7EB;
    background: none;
}

.filter:hover {
    color: #2563EB;
    background-color: #EFF6FF;
    cursor: pointer;
}
</style>