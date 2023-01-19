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
      // chartData: {
      //   labels: ["January", "February", "March", "April", "May", "June", "July"],
      //   datasets: [
      //     {
      //       label: "Data One",
      //       backgroundColor: "#7c3aed",
      //       data: [40, 39, 10, 40, 39, 80, 40]
      //     }
      //   ]
      // }
    };
  }
};
</script>
