<script setup>

</script>

<template>
    <div class="measuremnt">
        <div class="header">
            <p>Meausremnt Name</p>
            <button>
                <img src="../assets/options.svg" alt="">
            </button>
        </div>
        <div class="content">
            <div class="value">
                <div>85</div>
                <div>Good</div>
            </div>
        </div>
    </div>

</template>

<style>

    .measuremnt {
        border-radius: 0.5rem;
        border: 0px solid #E5E7EB;
        background: #FFF;
        box-shadow: 0px 1px 2px 0px rgba(0, 0, 0, 0.05);
        display: flex;
        justify-content: center;
        align-items: flex-start;
        width: 28rem;
        padding: 1.5rem;
    }

    .header {
        display: flex;
        height: 1.5rem;
        padding: 0.125rem 0rem;
        justify-content: center;
        align-items: center;
        gap: 16.75rem;
    }
</style>