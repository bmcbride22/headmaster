<template>
  <Line :data="chartData" :options="chartOptions" @click="onClick" />
</template>

<script>
import { Chart as ChartJS, CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend } from "chart.js";
import { Line } from "vue-chartjs";
ChartJS.register(CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend);

export default {
  name: "LineChart",
  // eslint-disable-next-line vue/no-reserved-component-names
  components: { Line },
  props: {
    chartData: {
      type: Object,
      default: () => {
        return {
          labels: ["January", "February", "March", "April", "May", "June", "July"],
          datasets: [
            {
              label: "Cohort 1 Average",
              backgroundColor: "#4c1d95",
              lineColor: "#4c1d95",
              borderColor: "#4c1d95",
              data: [65, 59, 56, 64, 72, 80, 81],
              pointStyle: "circle",
              pointRadius: 5
            },
            {
              label: "Cohort 2 Average",
              backgroundColor: "#8b5cf6",
              borderColor: "#8b5cf6",
              data: [60, 63, 59, 65, 68, 70, 75],
              pointStyle: "circle",
              pointRadius: 5
            },
            {
              label: "Cohort 3 Average",
              backgroundColor: "#c4b5fd",
              borderColor: "#c4b5fd",
              data: [55, 57, 63, 60, 64, 70, 72],
              pointStyle: "circle",
              pointRadius: 5
            }
          ]
        };
      }
    }
  },
  data() {
    return {
      chartOptions: {
        plugins: {
          legend: {
            labels: {
              usePointStyle: true
            }
          }
        },
        responsive: true
      }
    };
  }
};
</script>
