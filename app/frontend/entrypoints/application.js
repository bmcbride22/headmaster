import "./main.scss";

import { createApp } from "vue/dist/vue.esm-bundler";
// import Home from "../components/views/Home.vue";

import BarChart from "../components/views/BarChart.vue";
import DoughnutChart from "../components/views/DoughnutChart.vue";
import LineChart from "../components/views/LineChart.vue";
import EasyTable from "../components/views/EasyTable.vue";

const app = createApp({
  data() {
    return {
      message: "Hello Vue 3 and Rails"
    };
  }
});

// import (and use) the components one by one
// app.component("Home", Home);
app.component("EasyTable", EasyTable);
app.component("LineChart", LineChart);
app.component("DoughnutChart", DoughnutChart);
app.component("BarChart", BarChart);
app.mount("#vue-chart");
