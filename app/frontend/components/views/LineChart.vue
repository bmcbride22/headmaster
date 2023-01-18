<template>
  <Line :data="chartData" :options="chartOptions" />
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
      default: () => {}
    }
  },
  data() {
    return {
      chartOptions: {
        responsive: true,
        maintainAspectRatio: false
      }
    };
  }
};
</script>
