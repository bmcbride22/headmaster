<template>
  <Bar id="my-chart-id" :options="chartOptions" :data="chartData" />
</template>

<script>
import { Bar } from "vue-chartjs";
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from "chart.js";

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale);

export default {
  name: "BarChart",
  components: { Bar },
  props: {
    chartData: {
      type: Object,
      default: () => {}
    }
  },
  data() {
    return {
      // chartData: {
      //   labels: ["January", "February", "March"],
      //   datasets: [{ data: [40, 20, 12] }]
      // },
      chartOptions: {
        responsive: true,
        hoverBackgroundColor: "#f97316",
        plugins: {
          tooltip: {
            backgroundColor: "#f5f3ff",
            titleColor: "#6d28d9",
            bodyColor: "#f97316",
            borderColor: "#f5f3ff",
            borderWidth: 2,
            caretPadding: 10,
            cornerRadius: 6,
            displayColors: false,
            padding: 10,
            titleFont: {
              family: "segoe-ui, sans-serif",
              size: 16,
              weight: "bold"
            },
            bodyFont: {
              family: "segoe-ui, sans-serif",
              size: 16
            }
          }
        }
      }
    };
  }
};
</script>
