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
        labels: ["A", "B", "C", "D"],
        datasets: [{ backgroundColor: ["#5b21b6", "#7c3aed", "#a78bfa", "#ddd6fe"], data: [15, 45, 30, 10] }]
      },
      chartOptions: {
        responsive: true
      }
    };
  }
};
</script>
