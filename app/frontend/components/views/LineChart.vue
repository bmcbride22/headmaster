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
    propData: {
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
      chartData: {
        labels: this.propData.labels,
        datasets: this.propData.datasets
      },
      chartOptions: {
        pointHitRadius: 10,
        pointHoverRadius: 6,

        hoverBackgroundColor: "#f97316",
        hoverBorderColor: "#f97316",
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
            beforeInit(chart) {
              const originalFit = chart.legend.fit;
              chart.legend.fit = function fit() {
                originalFit.bind(chart.legend)();
                this.height += 100;
              };
            },

            position: "top",

            onClick: (event, legendItem, legend) => {
              const index = legendItem.datasetIndex;
              console.log(legend.chart.data.datasets[index].originalColor);
              legend.chart.data.datasets.forEach((data, i) => {
                if (i !== index && data.backgroundColor === "#f97316") {
                  data.backgroundColor = data.originalColor;
                  data.borderColor = data.originalColor;
                  data.lineColor = data.originalColor;
                }
              });

              if (legend.chart.data.datasets[index].backgroundColor === "#f97316") {
                legend.chart.data.datasets[index].backgroundColor = legend.chart.data.datasets[index].originalColor;
                legend.chart.data.datasets[index].borderColor = legend.chart.data.datasets[index].originalColor;
                legend.chart.data.datasets[index].lineColor = legend.chart.data.datasets[index].originalColor;
              } else {
                legend.chart.data.datasets[index].originalColor = legend.chart.data.datasets[index].backgroundColor;

                legend.chart.data.datasets[index].backgroundColor = "#f97316";
                legend.chart.data.datasets[index].borderColor = "#f97316";
                legend.chart.data.datasets[index].lineColor = "#f97316";
              }
              legend.chart.update();
            },

            labels: {
              pointStyleWidth: 24,
              usePointStyle: true,
              font: {
                family: "segoe-ui, sans-serif",
                size: 16
              },
              padding: 20
            }
          }
        },

        responsive: true
      }
    };
  }
};
</script>
