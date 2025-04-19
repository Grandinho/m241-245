<script setup lang="ts">
import { ref, onMounted, onUnmounted, computed, watch } from "vue";
import Chart from "chart.js/auto";
import type { ISensorReading } from "@/sensorReading/ISensorReading";

const chartRef = ref<HTMLCanvasElement | null>(null);

const props = defineProps<{
    sensorReadings: ISensorReading[];
    dataType: 'temperature' | 'humidity' | 'carbondioxide' | 'airQualityIndex';
    title: string;
}>();

const filterByDay = ref<boolean>(true);
const filterByWeek = ref<boolean>(false);
const filterByMonth = ref<boolean>(false);

function updateFilter(filter: string) {
    switch (filter) {
        case "day": {
            if (filterByDay.value) return;
            filterByDay.value = true;
            filterByWeek.value = false;
            filterByMonth.value = false;
            break;
        }
        case "week": {
            if (filterByWeek.value) return;
            filterByDay.value = false;
            filterByWeek.value = true;
            filterByMonth.value = false;
            break;
        }
        case "month": {
            if (filterByMonth.value) return;
            filterByDay.value = false;
            filterByWeek.value = false;
            filterByMonth.value = true;
            break;
        }
        default: {
            console.warn(`Unknown filter type: ${filter}`);
        }
    }

    updateChart();
}

const datasetConfigs = {
    temperature: {
        label: "Temperature (°C)",
        borderColor: "blue",
        backgroundColor: "rgba(0, 0, 255, 0.1)",
        pointBackgroundColor: "blue",
        pointBorderColor: "#fff",
        min: -10,
        max: 50
    },
    humidity: {
        label: "Humidity (%)",
        borderColor: "green",
        backgroundColor: "rgba(0, 255, 0, 0.1)",
        pointBackgroundColor: "green",
        pointBorderColor: "#fff",
        min: 0,
        max: 100
    },
    carbondioxide: {
        label: "CO₂ (ppm)",
        borderColor: "red",
        backgroundColor: "rgba(255, 0, 0, 0.1)",
        pointBackgroundColor: "red",
        pointBorderColor: "#fff",
        min: 0,
        max: 5000
    },
    airQualityIndex: {
        label: "Air Quality",
        borderColor: "purple",
        backgroundColor: "rgba(128, 0, 128, 0.1)",
        pointBackgroundColor: "purple",
        pointBorderColor: "#fff",
        min: 0,
        max: 500
    }
};

const chartData = computed(() => {
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
    const data = filteredReadings.map(reading => reading[props.dataType]);

    // Create array to determine which points should have visible markers
    const pointRadiusArray = generatePointRadiusArray(data.length);

    return {
        labels,
        data,
        pointRadiusArray
    };
});

// Generate an array that determines which points should be visible
const generatePointRadiusArray = (dataLength: number): number[] => {
    if (dataLength === 0) return [];

    const pointRadiusArray = new Array(dataLength).fill(0);

    // Determine interval based on data length
    let interval: number;
    if (filterByDay.value) {
        interval = Math.max(1, Math.floor(dataLength / 8)); // Show about 8 points for day view
    } else if (filterByWeek.value) {
        interval = Math.max(1, Math.floor(dataLength / 14)); // Show about 14 points for week view (2 per day)
    } else {
        interval = Math.max(1, Math.floor(dataLength / 31)); // Show about 31 points for month view (1 per day)
    }

    // Always show first and last point
    if (dataLength > 0) {
        pointRadiusArray[0] = 4;
        pointRadiusArray[dataLength - 1] = 4;
    }

    // Show points at regular intervals
    for (let i = interval; i < dataLength - 1; i += interval) {
        pointRadiusArray[i] = 4;
    }

    return pointRadiusArray;
};

let chartInstance: Chart | null = null;

onMounted(() => {
    updateChart();
});

onUnmounted(() => {
    if (chartInstance) {
        chartInstance.destroy();
    }
});

const updateChart = () => {
    if (chartRef.value && props.sensorReadings.length > 0) {
        const ctx = chartRef.value.getContext("2d");
        if (ctx) {
            if (chartInstance) {
                chartInstance.destroy();
            }

            const config = datasetConfigs[props.dataType];

            chartInstance = new Chart(ctx, {
                type: "line",
                data: {
                    labels: chartData.value.labels,
                    datasets: [{
                        label: config.label,
                        data: chartData.value.data,
                        borderColor: config.borderColor,
                        backgroundColor: config.backgroundColor,
                        pointBackgroundColor: config.pointBackgroundColor,
                        pointBorderColor: config.pointBorderColor,
                        pointBorderWidth: 1,
                        pointRadius: chartData.value.pointRadiusArray,
                        pointHoverRadius: 6,
                        fill: true,
                        tension: 0.4,
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: true },
                        tooltip: {
                            mode: 'index',
                            intersect: false,
                            callbacks: {
                                title: function (tooltipItems) {
                                    return tooltipItems[0].label;
                                },
                                label: function (context) {
                                    let label = context.dataset.label || '';
                                    if (label) {
                                        label += ': ';
                                    }
                                    label += context.parsed.y;
                                    return label;
                                }
                            }
                        }
                    },
                    interaction: {
                        intersect: false,
                        mode: 'nearest'
                    },
                    scales: {
                        x: {
                            title: { display: true, text: "Timestamp" },
                            ticks: {
                                maxRotation: 45,
                                minRotation: 45,
                                autoSkip: true,
                                maxTicksLimit: 15
                            }
                        },
                        y: {
                            title: { display: true, text: config.label },
                            min: config.min,
                            max: config.max
                        },
                    },
                },
            });
        }
    }
};

watch(() => props.sensorReadings, (newVal, oldVal) => {
    if (newVal !== oldVal) {
        updateChart();
    }
}, { deep: true });

watch(() => [filterByDay.value, filterByWeek.value, filterByMonth.value], () => {
    updateChart();
});
</script>

<template>
    <div class="statistics-chart">
        <div class="header">
            <h3 class="chart-title" :style="{ color: datasetConfigs[dataType].borderColor }">{{ title }}</h3>
            <div class="filters">
                <button class="filter" :class="{ 'filter-selected': filterByDay }"
                    @click="updateFilter('day')">Day</button>
                <button class="filter" :class="{ 'filter-selected': filterByWeek }"
                    @click="updateFilter('week')">Week</button>
                <button class="filter" :class="{ 'filter-selected': filterByMonth }"
                    @click="updateFilter('month')">Month</button>
            </div>
        </div>
        <div class="content">
            <canvas ref="chartRef"></canvas>
            <div v-if="props.sensorReadings.length === 0" class="no-data">
                No sensor data available
            </div>
        </div>
    </div>
</template>

<style scoped>
.statistics-chart {
    display: flex;
    padding: 16px;
    flex-direction: column;
    align-items: flex-start;
    gap: 12px;
    background: #FFF;
    box-shadow: 0px 1px 2px 0px rgba(0, 0, 0, 0.05);
    border-radius: 8px;
    border: 0px solid #E5E7EB;
    height: 350px;
}

.header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
}

.chart-title {
    font-size: 16px;
    font-weight: 600;
    margin: 0;
}

.content {
    border-radius: 8px;
    border: 0px solid #E5E7EB;
    background: #F9FAFB;
    width: 100%;
    height: 100%;
    height: calc(100% - 40px);
    position: relative;
}

.no-data {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    font-size: 14px;
    color: #6B7280;
}

.filters {
    display: flex;
    justify-content: start;
    align-items: center;
    gap: 6px;
}

.filter {
    display: flex;
    padding: 4px 10px;
    justify-content: center;
    align-items: center;
    flex-shrink: 0;
    border-radius: 9999px;
    border: 1px solid #E5E7EB;
    background: none;
    font-size: 12px;
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