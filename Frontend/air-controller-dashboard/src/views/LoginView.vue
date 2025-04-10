<script setup lang="ts">

</script>

<template>
    <div class="container">
        <div class="form-container">
            d
        </div>
    </div>

</template>

<style scoped>
.container {
    position: fixed;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    z-index: 1;
    margin: 0px;
    padding: 0px;
    overflow: hidden;
}

.form-container {
    position: fixed;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%);
    width: 20%;
    height: 45%;
    background-color: #F9FAFB;
    box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
    border-radius: 10px;
    display: flex;
    flex-direction: column;
    align-items: center;
}
</style>