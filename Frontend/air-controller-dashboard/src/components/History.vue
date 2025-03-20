<script setup lang="ts">
import { ref, onMounted, onUnmounted, computed } from "vue";
import Chart from "chart.js/auto";
 
const temperatureChart = ref<HTMLCanvasElement | null>(null);
const selectedDataset = ref<"temperature" | "humidity" | "gasReadings" | "pressure">("temperature");
const showDropdown = ref(false);
const dropdownRef = ref<HTMLElement | null>(null);
 
const datasets: Record<string, { label: string; data: number[]; borderColor: string; backgroundColor: string; fill: boolean; tension: number }> = {
  temperature: {
    label: "Temperatur (°C)",
    data: [5, 7, 10, 15, 20, 22, 18, 12, 8, 5],
    borderColor: "blue",
    backgroundColor: "rgba(0, 0, 255, 0.1)",
    fill: true,
    tension: 0.4
  },
  humidity: {
    label: "Luftfeuchtigkeit (%)",
    data: [30, 35, 40, 50, 60, 55, 45, 35, 33, 30],
    borderColor: "green",
    backgroundColor: "rgba(0, 255, 0, 0.1)",
    fill: true,
    tension: 0.4
  },
  gasReadings: {
    label: "Gaswerte (ppm)",
    data: [100, 200, 150, 300, 250, 400, 350, 280, 220, 100],
    borderColor: "red",
    backgroundColor: "rgba(255, 0, 0, 0.1)",
    fill: true,
    tension: 0.4
  },
  pressure: {
    label: "Druck (hPa)",
    data: [1010, 1012, 1015, 1018, 1020, 1017, 1013, 1011, 1008, 1010],
    borderColor: "purple",
    backgroundColor: "rgba(128, 0, 128, 0.1)",
    fill: true,
    tension: 0.4
  }
};
 
const selectedColor = computed(() => datasets[selectedDataset.value].borderColor);
 
let chartInstance: Chart | null = null;
 
onMounted(() => {
  updateChart();
  document.addEventListener("click", handleClickOutside);
});
 
onUnmounted(() => {
  document.removeEventListener("click", handleClickOutside);
});
 
const updateChart = () => {
  if (temperatureChart.value) {
    const ctx = temperatureChart.value.getContext("2d");
    if (ctx) {
      if (chartInstance) {
        chartInstance.destroy();
      }
      chartInstance = new Chart(ctx, {
        type: "line",
        data: {
          labels: ["00:00", "03:00", "06:00", "09:00", "12:00", "15:00", "18:00", "21:00", "23:00", "00:00"],
          datasets: datasets[selectedDataset.value] ? [datasets[selectedDataset.value]] : []
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: { display: true },
          },
          scales: {
            x: { title: { display: true, text: "Uhrzeit" } },
            y: { title: { display: true, text: datasets[selectedDataset.value]?.label || "" } },
          },
        },
      });
    }
  }
};
 
const handleClickOutside = (event: MouseEvent) => {
  if (dropdownRef.value && !dropdownRef.value.contains(event.target as Node)) {
    showDropdown.value = false;
  }
};
</script>
 
<template>
<div class="history">
<div class="header">
<div class="dropdown-container" ref="dropdownRef" @click="showDropdown = !showDropdown">
<span class="selected-text" :style="{ color: selectedColor }">{{ datasets[selectedDataset].label }}</span> - Historical Data
<div v-if="showDropdown" class="dropdown-menu">
<div v-for="(dataset, key) in datasets" :key="key"
             @click="selectedDataset = key as any; showDropdown = false; updateChart()"
             :class="{ 'selected': selectedDataset === key }">
          {{ dataset.label }}
</div>
</div>
</div>
<div class="filters">
<button class="filter">Day</button>
<button class="filter">Week</button>
<button class="filter">Month</button>
</div>
</div>
<div class="content">
<canvas ref="temperatureChart"></canvas>
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
    width: 95%;
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
    width: 100%;
    height: 400px;
}
 
.dropdown-container {
    position: relative;
    cursor: pointer;
    font-size: 16px;
    font-weight: 600;
    color: #000;
}
 
.selected-text {
    font-weight: bold;
}
 
.dropdown-menu {
    position: absolute;
    background: white;
    border: 1px solid #E5E7EB;
    border-radius: 4px;
    margin-top: 4px;
    box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
    z-index: 10;
}
 
.dropdown-menu div {
    padding: 8px 12px;
    cursor: pointer;
}
 
.dropdown-menu div:hover,
.selected {
    background: #EFF6FF;
    color: #2563EB;
}
 
.filters {
    display: flex;
    justify-content: start;
    align-items: center;
    gap: 8px;
}
 
.filter {
    display: flex;
    padding: 5px 12px;
    justify-content: center;
    align-items: center;
    flex-shrink: 0;
    border-radius: 9999px;
    border: 1px solid #E5E7EB;
    background: none;
    font-size: 14px;
    font-weight: 500;
    color: #000;
    transition: all 0.3s ease;
}
 
.filter:hover {
    color: #2563EB;
    background-color: #EFF6FF;
    cursor: pointer;
}
 
.filter:active {
    background-color: #DBEAFE;
}
</style>