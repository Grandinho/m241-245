<script setup lang="ts">

</script>

<template>
    <div class="device-status">
        <div class="header">
            <div class="title">Device Status</div>
            <button class="refresh">
                <img src="../assets/refresh.svg" alt="" class="refresh-img">
            </button>
        </div>
        <div class="content">
            <div class="item" v-for="n in 3">
                <div class="item-info">
                    <img src="../assets/battery.svg" alt="" class="item-info-img">
                    <div class="item-info-text">Battery Level</div>
                </div>
                <div class="item-value">
                    85%
                </div>
            </div>
        </div>
    </div>

</template>

<style scoped>
.device-status {
    display: flex;
    padding: 24px 24px 24px 24px;
    flex-direction: column;
    align-items: flex-start;
    gap: 16px;
    border-radius: 8px;
    border: 0px solid #E5E7EB;
    background: #FFF;
    height: 500px;
}

.header {
    display: flex;
    padding: 2px 0px;
    justify-content: space-between;
    align-items: center;
    width: 100%;
}

.title {
    color: #000;
    font-size: 16px;
    font-style: normal;
    font-weight: 600;
    line-height: 16px;
}

button {
    width: 16px;
    height: 16px;
    border: 0px solid #E5E7EB;
    background: rgba(0, 0, 0, 0.00);
}

.content {
    width: 100%;
    display: flex;
    gap: 12px;
    flex-direction: column;
}

.item {
    display: flex;
    padding: 10px;
    justify-content: space-between;
    flex-shrink: 0;
    border-radius: 8px;
    border: 0px solid #E5E7EB;
    background: #F9FAFB;
}

.item-info {
    display: flex;
    align-items: center;
    gap: 5px;
}

.item-info-text {
    color: #000;
    font-size: 14px;
    font-style: normal;
    font-weight: 400;
}

.item-info-img {
    width: 18px;
    height: 16px;
}

.item-value {
    color: #000;
    font-family: Inter;
    font-size: 14px;
    font-style: normal;
    font-weight: 400;
    line-height: normal;
}

.refresh-img {
    width: 16px;
    height: 16px;
    flex-shrink: 0;
}

.refresh-img:hover {
    cursor: pointer;
    filter: invert(52%) sepia(100%) saturate(6061%) hue-rotate(217deg) brightness(95%) contrast(93%);
}
</style>