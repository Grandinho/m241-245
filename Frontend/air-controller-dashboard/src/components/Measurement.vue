<script setup lang="ts">
const props = defineProps<{
    title: string;
    value: number;
    uom: string;
    indicator: string;
    date: string;
    type?: string;
}>();

import { ref, computed } from 'vue';

const showPopup = ref(false);
const selectedOption = ref('');

const airQualityData = [
    { from: 0, to: 50, category: 'Good', description: 'Air quality is good and poses little or no risk.', color: '#22C55E', improvement: 'Current air quality is excellent. Continue to support clean air initiatives.' },
    { from: 51, to: 100, category: 'Moderate', description: 'Air quality is acceptable but may cause concern for some people who are sensitive to air pollution.', color: '#FACC15', improvement: 'Consider reducing prolonged outdoor activities if you are sensitive to air pollution.' },
    { from: 101, to: 150, category: 'Unhealthy for Sensitive Groups', description: 'Members of sensitive groups may experience health effects.', color: '#F97316', improvement: 'Sensitive groups should reduce outdoor exertion. Consider using air purifiers indoors.' },
    { from: 151, to: 200, category: 'Unhealthy', description: 'Everyone may begin to experience health effects.', color: '#EF4444', improvement: 'Limit outdoor activities. Keep windows closed. Use air purifiers if available.' },
    { from: 201, to: 300, category: 'Very Unhealthy', description: 'Health alert: everyone may experience more serious health effects.', color: '#A855F7', improvement: 'Avoid outdoor activities. Use masks when going outside. Use air purifiers indoors.' },
    { from: 301, to: 500, category: 'Hazardous', description: 'Health warnings of emergency conditions.', color: '#7F1D1D', improvement: 'Stay indoors with filtered air. Wear N95 masks if going outside is necessary. Follow local health advisories.' }
];

const temperatureData = [
    { from: -20, to: 0, category: 'Very Cold', description: 'Extremely cold conditions that may pose risk of hypothermia.', color: '#1E40AF', improvement: 'Ensure proper heating. Wear multiple layers of clothing. Minimize time outdoors.' },
    { from: 0, to: 15, category: 'Cold', description: 'Cold conditions that require warm clothing.', color: '#3B82F6', improvement: 'Wear appropriate warm clothing. Ensure heating systems are working properly.' },
    { from: 15, to: 25, category: 'Moderate', description: 'Comfortable temperature range for most activities.', color: '#22C55E', improvement: 'Current temperature is comfortable. No specific actions needed.' },
    { from: 25, to: 35, category: 'Warm', description: 'Warm conditions that may cause discomfort for some people.', color: '#F97316', improvement: 'Stay hydrated. Use fans or air conditioning if available.' },
    { from: 35, to: 50, category: 'Hot', description: 'Hot conditions that may pose risk of heat-related illness.', color: '#EF4444', improvement: 'Limit outdoor activities during peak hours. Stay in air-conditioned spaces. Drink plenty of water.' }
];

const humidityData = [
    { from: 0, to: 30, category: 'Very Dry', description: 'Very dry conditions that may cause skin and respiratory irritation.', color: '#F97316', improvement: 'Use a humidifier. Keep plants indoors. Drink plenty of water.' },
    { from: 30, to: 40, category: 'Dry', description: 'Dry conditions that may cause minor discomfort.', color: '#FACC15', improvement: 'Consider using a humidifier, especially in sleeping areas.' },
    { from: 40, to: 60, category: 'Optimal', description: 'Ideal humidity range for comfort and health.', color: '#22C55E', improvement: 'Current humidity is optimal. Continue monitoring to maintain this level.' },
    { from: 60, to: 70, category: 'Humid', description: 'Humid conditions that may cause discomfort and promote mold growth.', color: '#FACC15', improvement: 'Use a dehumidifier. Ensure proper ventilation. Check for and address any mold growth.' },
    { from: 70, to: 100, category: 'Very Humid', description: 'Very humid conditions that promote mold growth and may worsen respiratory conditions.', color: '#EF4444', improvement: 'Use dehumidifiers. Improve ventilation. Check for mold. Use air conditioning when possible.' }
];

const measurementData = computed(() => {
    const titleLower = props.title.toLowerCase();
    if (titleLower.includes('air') || titleLower.includes('aqi')) {
        return airQualityData;
    } else if (titleLower.includes('temp') || titleLower.includes('temperature')) {
        return temperatureData;
    } else if (titleLower.includes('humid') || titleLower.includes('humidity')) {
        return humidityData;
    }
    return airQualityData;
});

const currentCategory = computed(() => {
    for (const item of measurementData.value) {
        if (props.value >= item.from && props.value <= item.to) {
            return item;
        }
    }
    return null;
});

const valueColor = computed(() => {
    return currentCategory.value ? currentCategory.value.color : '#22C55E';
});

const bgGradient = computed(() => {
    const color = valueColor.value;
    return `radial-gradient(circle, ${color}20 0%, rgba(249, 250, 251, 100) 100%)`;
});

const toggleDropdown = ref(false);

const openPopup = (option: string) => {
    selectedOption.value = option;
    showPopup.value = true;
    toggleDropdown.value = false;
};

const closePopup = () => {
    showPopup.value = false;
};

const handleClickOutside = (event: Event) => {
    const popup = document.querySelector('.popup-content');
    const optionsBtn = document.querySelector('.options');

    if (popup && !popup.contains(event.target as Node) &&
        optionsBtn && !optionsBtn.contains(event.target as Node)) {
        closePopup();
        toggleDropdown.value = false;
    }
};

import { onMounted, onBeforeUnmount } from 'vue';

onMounted(() => {
    document.addEventListener('mousedown', handleClickOutside);
});

onBeforeUnmount(() => {
    document.removeEventListener('mousedown', handleClickOutside);
});
</script>

<template>
    <div class="measuremnt">
        <div class="header">
            <div class="title">{{ title }}</div>
            <div class="dropdown-container">
                <button class="options" @click="toggleDropdown = !toggleDropdown">
                    <img src="../assets/options.png" alt="" class="options-img">
                </button>
                <div v-if="toggleDropdown" class="dropdown-menu">
                    <button class="dropdown-item" @click="openPopup('ranges')">
                        View index ranges
                    </button>
                    <button class="dropdown-item" @click="openPopup('improvements')">
                        Improvements
                    </button>
                </div>
            </div>
        </div>

        <div class="content" :style="{ background: bgGradient }">
            <div class="value-content">
                <div class="value" :style="{ color: valueColor }">{{ value }} {{ uom }}</div>
                <div v-if="currentCategory" class="category" :style="{ color: valueColor }">
                    {{ currentCategory.category }}
                </div>
                <div class="indicator">{{ date }}</div>
            </div>
        </div>

        <div v-if="showPopup" class="popup-overlay">
            <div class="popup-content">
                <div class="popup-header">
                    <h3 class="popup-title">
                        {{ selectedOption === 'ranges' ? title + ' Ranges' : 'Improvement Recommendations' }}
                    </h3>
                    <button class="close-button" @click="closePopup">×</button>
                </div>

                <div v-if="selectedOption === 'ranges'" class="popup-body">
                    <div class="current-value-display">
                        <div class="current-value" :style="{ color: valueColor }">{{ value }} {{ uom }}</div>
                        <div v-if="currentCategory" class="current-category" :style="{ color: valueColor }">
                            {{ currentCategory.category }}
                        </div>
                    </div>

                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>Range</th>
                                    <th>Category</th>
                                    <th>Description</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="(item, index) in measurementData" :key="index"
                                    :class="{ 'active-row': value >= item.from && value <= item.to }">
                                    <td>{{ item.from }} - {{ item.to }}</td>
                                    <td>
                                        <span class="category-badge"
                                            :style="{ backgroundColor: `${item.color}20`, color: item.color }">
                                            {{ item.category }}
                                        </span>
                                    </td>
                                    <td>{{ item.description }}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div v-else class="popup-body improvements-content">
                    <h3 class="improvements-header">
                        Recommendations for {{ currentCategory?.category || 'Current' }} Conditions
                    </h3>
                    <div v-if="currentCategory" class="improvements-details">
                        <div class="improvement-card">
                            <div class="improvement-text">{{ currentCategory.improvement }}</div>
                        </div>
                        <div class="current-reading">
                            Current reading: <span class="reading-value" :style="{ color: valueColor }">{{ value }} {{
                                uom }}</span>
                            ({{ currentCategory.category }})
                        </div>
                        <div class="last-updated">
                            Last updated: {{ date }}
                        </div>
                    </div>
                    <div v-else class="no-recommendations">
                        No specific recommendations available for the current measurement value.
                    </div>
                </div>
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
    position: relative;
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
}

button {
    border: 0px solid #E5E7EB;
    background: rgba(0, 0, 0, 0.00);
}

.options {
    filter: brightness(0) saturate(100%) invert(44%) sepia(99%) saturate(1457%) hue-rotate(330deg) brightness(100%) contrast(93%);
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
    text-align: center;
    font-size: 36px;
    font-style: normal;
    font-weight: 700;
    line-height: normal;
}

.category {
    text-align: center;
    font-size: 18px;
    font-style: normal;
    font-weight: 600;
    line-height: normal;
    margin-top: 4px;
}

.indicator {
    color: #4B5563;
    text-align: center;
    font-size: 14px;
    font-style: normal;
    font-weight: 400;
    line-height: normal;
    margin-top: 6px;
}

.title {
    color: #000;
    font-size: 16px;
    font-style: normal;
    font-weight: 600;
    line-height: 16px;
}

.dropdown-container {
    position: relative;
}

.dropdown-menu {
    position: absolute;
    right: 0;
    top: 100%;
    width: 150px;
    background: white;
    border: 1px solid #E5E7EB;
    border-radius: 4px;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    z-index: 10;
    margin-top: 4px;
}

.dropdown-item {
    display: block;
    width: 100%;
    text-align: left;
    padding: 8px 12px;
    color: #4B5563;
    font-size: 14px;
    cursor: pointer;
    transition: background-color 0.2s;
}

.dropdown-item:hover {
    background-color: #F9FAFB;
}

.popup-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(0, 0, 0, 0.5);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 1000;
}

.popup-content {
    background: white;
    border-radius: 8px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    width: 90%;
    max-width: 600px;
    max-height: 90vh;
    overflow-y: auto;
    display: flex;
    flex-direction: column;
}

.popup-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 16px 20px;
    border-bottom: 1px solid #E5E7EB;
}

.popup-title {
    font-size: 18px;
    font-weight: 600;
    color: #111827;
    margin: 0;
}

.close-button {
    background: transparent;
    border: none;
    font-size: 24px;
    color: #6B7280;
    cursor: pointer;
    padding: 0;
    line-height: 1;
    transition: color 0.2s;
}

.close-button:hover {
    color: #111827;
}

.popup-body {
    padding: 20px;
}

.current-value-display {
    display: flex;
    flex-direction: column;
    align-items: center;
    margin-bottom: 24px;
    padding: 16px;
    background: #F9FAFB;
    border-radius: 8px;
}

.current-value {
    font-size: 32px;
    font-weight: 700;
}

.current-category {
    font-size: 18px;
    font-weight: 600;
    margin-top: 4px;
}

.table-container {
    border-radius: 4px;
    overflow-x: auto;
    border: 1px solid #E5E7EB;
}

table {
    width: 100%;
    border-collapse: collapse;
    font-size: 14px;
}

thead {
    background-color: #F9FAFB;
}

th {
    text-align: left;
    padding: 12px 16px;
    color: #6B7280;
    font-weight: 500;
}

td {
    padding: 12px 16px;
    border-top: 1px solid #E5E7EB;
    color: #4B5563;
}

.active-row {
    background-color: #F9FAFB;
}

.category-badge {
    display: inline-block;
    padding: 4px 10px;
    border-radius: 9999px;
    font-size: 12px;
    font-weight: 500;
}

.improvements-content {
    display: flex;
    flex-direction: column;
}

.improvements-header {
    font-size: 16px;
    font-weight: 600;
    color: #111827;
    margin-bottom: 16px;
}

.improvements-details {
    display: flex;
    flex-direction: column;
    gap: 16px;
}

.improvement-card {
    background-color: #F9FAFB;
    border: 1px solid #E5E7EB;
    border-radius: 8px;
    padding: 16px;
}

.improvement-text {
    color: #4B5563;
    font-size: 15px;
    line-height: 1.5;
}

.current-reading {
    font-size: 14px;
    color: #6B7280;
    margin-top: 8px;
}

.reading-value {
    font-weight: 600;
}

.last-updated {
    font-size: 14px;
    color: #9CA3AF;
    margin-top: 4px;
}

.no-recommendations {
    color: #6B7280;
    font-size: 14px;
    padding: 16px;
    background-color: #F9FAFB;
    border-radius: 8px;
    border: 1px solid #E5E7EB;
}
</style>