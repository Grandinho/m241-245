<script lang="ts">

</script>

<template>
    <div class="container">
        <div class="form-container">
            <h3>Add New Device</h3>
            <form class="form" v-on:submit="">
                <div class="form-item">
                    <label for="macAddress" class="form-label">MAC-Address</label>
                    <input type="text" id="macAddress" name="macAddress" class="form-input"
                        placeholder="Enter device MAC-Address...">
                </div>
                <div class="form-item">
                    <label for="name" class="form-label">Name</label>
                    <input type="text" id="name" name="name" class="form-input" placeholder="Enter device Name...">
                </div>
                <div class="form-item">
                    <label for="localization" class="form-label">Localization</label>
                    <input type="text" id="localization" name="localization" class="form-input"
                        placeholder="Enter device localization...">
                </div>
                <div class="buttons">
                    <button type="submit" class="form-button">Add device</button>
                    <button type="button" class="form-button">Cancel</button>
                </div>
            </form>
        </div>
    </div>

</template>

<style>
html,
body {
    margin: 0;
    height: 100%;
    overflow: hidden
}

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

.form {
    display: flex;
    flex-direction: column;
    align-items: center;
    margin: 20px;
    gap: 10px;
    width: 100%;
}

.buttons {
    display: flex;
    margin-top: 10%;
    justify-content: space-evenly;
    width: 100%;
}

.form-button {
    width: 110px;
    height: 35px;
    border: 2px solid #2563EB;
    border-radius: 5px;
    background-color: #2563EB;
    color: #F9FAFB;
    font-size: 14px;
}

.form-button:hover {
    background-color: #256FFB;
    color: #F9FAAA;
}

.form-item {
    display: flex;
    flex-direction: column;
    gap: 2px;
    width: 80%;
}

.form-label {
    font-size: 12px;
    color: #A9A9A9;
}

.form-input {
    border: none;
    border-radius: 5px;
    height: 30px;
    box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
    border: 2px solid #F9FAFB;
}

.form-input:focus {
    outline: none;
    border: 2px solid #2563EB;
}

.form-input::placeholder {
    color: lightgray;
}
</style>