<script setup lang="ts">
import { ref, onMounted, onUnmounted, computed, triggerRef, watch } from "vue";
import Chart from "chart.js/auto";
import type { ISensorReading } from "@/sensorReading/ISensorReading";

const temperatureChart = ref<HTMLCanvasElement | null>(null);
const selectedDataset = ref<"temperature" | "humidity" | "carbondioxide" | "airQualityIndex">("temperature");
const showDropdown = ref(false);
const dropdownRef = ref<HTMLElement | null>(null);
const props = defineProps<{
  sensorReadings: ISensorReading[]
}>()


const filterByDay = ref<boolean>(true);
const filterByWeek = ref<boolean>(false);
const filterByMonth = ref<boolean>(false);

function updateFilter(filter: string) {
  console.log(filter)
  switch (filter) {
    case "day": {
      if (filterByDay.value)
        return;
      filterByDay.value = true;
      filterByWeek.value = false;
      filterByMonth.value = false;
      break;
    }
    case "week": {
      if (filterByWeek.value)
        return;
      filterByDay.value = false
      filterByWeek.value = true
      filterByMonth.value = false
      break;
    }
    case "month": {
      if (filterByMonth.value)
        return;
      filterByDay.value = false
      filterByWeek.value = false
      filterByMonth.value = true
      break;
    }
    default: {
      console.warn(`Unknown filter type: ${filter}`);
    }
  }

  updateChart()

}




const getChartData = computed(() => {
  const sensorReadingsOrderedbyDate = [...props.sensorReadings].sort((a, b) => {
    const dateA: number = new Date(a.createdAt).getTime();
    const dateB: number = new Date(b.createdAt).getTime();
    return dateA - dateB;
  });

  const today = new Date();
  let timeThreshold: number;

  if (filterByDay.value) {
    timeThreshold = today.getTime() - (1 * 24 * 60 * 60 * 1000); // 1 day
  } else if (filterByWeek.value) {
    timeThreshold = today.getTime() - (7 * 24 * 60 * 60 * 1000); // 7 days
  } else {
    timeThreshold = today.getTime() - (31 * 24 * 60 * 60 * 1000); // 31 days
  }

  const filteredReadings = sensorReadingsOrderedbyDate.filter(reading =>
    new Date(reading.createdAt).getTime() > timeThreshold
  );

  const formatTime = (date: Date) => {
    if (filterByDay.value) {
      return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    } else if (filterByWeek.value) {
      return date.toLocaleDateString([], { weekday: 'short', day: '2-digit' }) + ' ' +
        date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    } else {
      return date.toLocaleDateString([], { month: "2-digit", day: '2-digit' }) + ' ' +
        date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    }
  };

  const labels = filteredReadings.map(reading => formatTime(new Date(reading.createdAt)));

  const temperatureData = filteredReadings.map(reading => reading.temperature);
  const humidityData = filteredReadings.map(reading => reading.humidity);
  const carbondioxideData = filteredReadings.map(reading => reading.carbondioxide);
  const airQualityData = filteredReadings.map(reading => reading.airQualityIndex);

  return {
    labels,
    datasets: {
      temperature: {
        label: "Temperature (°C)",
        data: temperatureData,
        borderColor: "blue",
        backgroundColor: "rgba(0, 0, 255, 0.1)",
        fill: true,
        tension: 0.8,
        min: -10,
        max: 50,
        pointRadius: 0
      },
      humidity: {
        label: "Humidity (%)",
        data: humidityData,
        borderColor: "green",
        backgroundColor: "rgba(0, 255, 0, 0.1)",
        fill: true,
        tension: 0.8,
        min: 0,
        max: 100,
        pointRadius: 0
      },
      carbondioxide: {
        label: "CO₂ (ppm)",
        data: carbondioxideData,
        borderColor: "red",
        backgroundColor: "rgba(255, 0, 0, 0.1)",
        fill: true,
        tension: 0.8,
        min: 0,
        max: 5000,
        pointRadius: 0
      },
      airQualityIndex: {
        label: "Air Quality",
        data: airQualityData,
        borderColor: "purple",
        backgroundColor: "rgba(128, 0, 128, 0.1)",
        fill: true,
        tension: 0.8,
        min: 0,
        max: 500,
        pointRadius: 0
      }
    }
  };
});

const selectedColor = computed(() => getChartData.value.datasets[selectedDataset.value].borderColor);

let chartInstance: Chart | null = null;

onMounted(() => {
  updateChart();
  document.addEventListener("click", handleClickOutside);
});

onUnmounted(() => {
  document.removeEventListener("click", handleClickOutside);
  if (chartInstance) {
    chartInstance.destroy();
  }
});

const updateChart = () => {
  if (temperatureChart.value && props.sensorReadings.length > 0) {
    const ctx = temperatureChart.value.getContext("2d");
    if (ctx) {
      if (chartInstance) {
        chartInstance.destroy();
      }

      const chartData = getChartData.value;

      chartInstance = new Chart(ctx, {
        type: "line",
        data: {
          labels: chartData.labels,
          datasets: chartData.datasets[selectedDataset.value] ? [chartData.datasets[selectedDataset.value]] : []
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: { display: true },
          },
          scales: {
            x: { title: { display: true, text: "Timestamp" } },
            y: { title: { display: true, text: chartData.datasets[selectedDataset.value]?.label || "" }, min: chartData.datasets[selectedDataset.value].min, max: chartData.datasets[selectedDataset.value].max },
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


watch(() => props.sensorReadings, (newVal, oldVal) => {
  if (newVal !== oldVal) {
    updateChart()
  }
})

</script>

<template>
  <div class="history">
    <div class="header">
      <div class="dropdown-container" ref="dropdownRef" @click="showDropdown = !showDropdown">
        <span class="selected-text" :style="{ color: selectedColor }">
          {{ getChartData.datasets[selectedDataset].label }}
        </span> - Historical Data
        <div v-if="showDropdown" class="dropdown-menu">
          <div v-for="(dataset, key) in getChartData.datasets" :key="key"
            @click="selectedDataset = key as any; showDropdown = false; updateChart()"
            :class="{ 'selected': selectedDataset === key }">
            {{ dataset.label }}
          </div>
        </div>
      </div>
      <div class="filters">
        <button class="filter" :class="{ 'filter-selected': filterByDay }" @click="updateFilter('day')">Day</button>
        <button class="filter" :class="{ 'filter-selected': filterByWeek }" @click="updateFilter('week')">Week</button>
        <button class="filter" :class="{ 'filter-selected': filterByMonth }"
          @click="updateFilter('month')">Month</button>
      </div>
    </div>
    <div class="content">
      <canvas ref="temperatureChart"></canvas>
      <div v-if="props.sensorReadings.length === 0" class="no-data">
        No sensor data available
      </div>
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
  height: 500px;
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
  height: 95%;
  position: relative;
}

.no-data {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  font-size: 16px;
  color: #6B7280;
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

.filter-selected {
  color: #2563EB;
  background-color: #EFF6FF;
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