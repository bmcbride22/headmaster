<template>
  <Doughnut id="doughnut-chart" :options="chartOptions" :data="chartData" />
</template>
<script>
import { Chart as ChartJS, ArcElement, Tooltip, Legend } from "chart.js";
import { Doughnut } from "vue-chartjs";

ChartJS.register(ArcElement, Tooltip, Legend);

export default {
  name: "DoughnutChart",
  components: { Doughnut },
  data() {
    return {
      chartData: {
        labels: [">85", "70-85", "55-70", "<55"],
        datasets: [{ backgroundColor: ["#5b21b6", "#7c3aed", "#a78bfa", "#ddd6fe"], data: [15, 45, 30, 10] }]
      },
      chartOptions: {
        responsive: true,
        plugins: {
          legend: {
            position: "bottom",
            labels: {
              color: "#5b21b6",
              font: {
                size: 10
              }
            }
          }
        }
      }
    };
  }
};
</script>
