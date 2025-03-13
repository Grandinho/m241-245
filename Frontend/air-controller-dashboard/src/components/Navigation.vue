<script setup lang="ts">
</script>

<template>
    <nav>
        <div class="navbar">
            <div class="logo">
                <img src="../assets/logo.svg" alt="logo" class="logo-img">
                <h3>IoT Dashboard</h3>
            </div>
            <div class="account">
                <img src="../assets/account-placeholder.jpg" alt="account" class="account-img">
            </div>
        </div>
    </nav>
</template>

<style scoped>
 nav {
    display: flex;
    padding: 0px 24px;
    padding-bottom: 1px;
    justify-content: center;
    align-items: center;
    flex-shrink: 0;
    border-bottom: 1px solid #E5E7EB;
    background: #FFF;
    height: 50px;
 }

 .navbar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    height: 50px;
    width: 100%;
 }

 .logo {
    display: flex;
    align-items: center;
    gap: 12px;
 }

 .logo-img {
    width: 24px;
    height: 24px;
 }

 .account-img {
    width: 32px;
    height: 32px;
    flex-shrink: 0;
    border-radius: 9999px;
    border: 0px solid #E5E7EB;
 }

</style>