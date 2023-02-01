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
      chartColors: ["#5b21b6", "#7c3aed", "#a78bfa", "#ddd6fe"],
      chartData: {
        labels: [">85", "70-85", "55-70", "<55"],
        datasets: [{ backgroundColor: ["#5b21b6", "#7c3aed", "#a78bfa", "#ddd6fe"], data: [15, 45, 30, 10] }]
      },
      chartOptions: {
        responsive: true,
        onHover: (event, elements, chart) => {
          if (elements.length > 0) {
            const index = elements[0].index;
            chart.data.datasets[0].backgroundColor.forEach((color, i, colors) => {
              if (i !== index && chart.data.datasets[0].selected !== i) {
                colors[i] = this.chartColors[i];
              } else {
                colors[i] = "#f97316";
              }
            });
          } else {
            chart.data.datasets[0].backgroundColor.forEach((color, i, colors) => {
              if (chart.data.datasets[0].selected !== i) {
                colors[i] = this.chartColors[i];
              }
            });
          }
        },
        plugins: {
          legend: {
            position: "right",
            labels: {
              color: "#5b21b6",
              font: {
                size: 10
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
