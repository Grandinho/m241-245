<script lang="ts">

</script>

<template>
<div class="container">
    <div class="form-container">
            <h3>Add new device</h3>
            <form class="form" v-on:submit="">
                <div class="form-item">
                    <label for="macAddress" class="form-label">MAC-Address</label>
                    <input type="text" id="macAddress" name="macAddress" class="form-input">
                </div>
                <div class="form-item">
                    <label for="name" class="form-label">Name</label>
                    <input type="text" id="name" name="name" class="form-input">
                </div>
                <div class="form-item">
                    <label for="localization" class="form-label">Localization</label>
                    <input type="text" id="localization" name="localization" class="form-input">
                </div>
                <button type="submit">Add device</button>
                <button type="button">Cancel</button>
            </form>
    </div>
</div>

</template>

<style>

html, body {margin: 0; height: 100%; overflow: hidden}

.container {
    position: fixed;
    width: 100%;
    height: 100%;
    background: rgba(0,0,0,0.5);
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
    background-color: #F9FAFB;
    box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
    border-radius: 10px;
    
}

.form {
    display: flex;
    flex-direction: column;
    margin: 20px;
    gap: 5px;
}

.form-item {
    display: flex;
    justify-content: space-between;
    gap: 10px;
}

.form-label {
 font-size: 14px;     
}
.form-input {
    border-radius: 5px;
}




</style>