<template>
  <Doughnut :options="chartOptions" :data="propData" />
</template>

<script>
import { Chart as ChartJS, ArcElement, Tooltip, Legend } from "chart.js";
import { Doughnut } from "vue-chartjs";

ChartJS.register(ArcElement, Tooltip, Legend);

export default {
  name: "DoughnutChart",
  components: { Doughnut },
  props: {
    propData: {
      type: Object,
      default: () => {
        return {
          labels: ["+85", "70-85", "55-70", "< 55"],
          datasets: [{ backgroundColor: ["#5b21b6", "#7c3aed", "#a78bfa", "#ddd6fe"], data: [15, 45, 30, 10] }]
        };
      }
    }
  },

  data() {
    return {
      chartColors: ["#5b21b6", "#7c3aed", "#a78bfa", "#ddd6fe"],
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
          },
          legend: {
            position: "right",
            title: {
              text: "Avg grade",
              display: true
            },
            labels: {
              usePointStyle: true,
              color: "#4b5563",

              font: {
                family: "segoe-ui, sans-serif",
                size: 12
              }
            },
            onClick: (event, legendItem, legend) => {
              const index = legendItem.index;
              legend.chart.data.datasets[0].backgroundColor.forEach((color, i, colors) => {
                if (i !== index) {
                  colors[i] = this.chartColors[i];
                } else {
                  if (legend.chart.data.datasets[0].selected === i) {
                    legend.chart.data.datasets[0].selected = null;
                    colors[i] = this.chartColors[i];
                  } else {
                    legend.chart.data.datasets[0].selected = i;
                    colors[i] = "#f97316";
                    console.log(legend.chart.data.datasets[0].selected);
                  }
                }
              });
              legend.chart.update();
            },
            onHover: (event, legendItem, legend) => {
              const index = legendItem.index;
              legend.chart.data.datasets[0].backgroundColor.forEach((color, i, colors) => {
                if (i !== index && legend.chart.data.datasets[0].selected !== i) {
                  colors[i] = this.chartColors[i];
                } else {
                  colors[i] = "#f97316";
                }
              });
              legend.chart.update();
            },
            onLeave: (event, legendItem, legend) => {
              const index = legendItem.index;
              legend.chart.data.datasets[0].backgroundColor.forEach((color, i, colors) => {
                if (legend.chart.data.datasets[0].selected === i) {
                  colors[i] = "#f97316";
                } else {
                  colors[i] = this.chartColors[i];
                }
              });
              legend.chart.update();
            }
          }
        }
      }
    };
  }
};
</script>
