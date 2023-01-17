import "./main.scss";

import { createApp } from "vue/dist/vue.esm-bundler";
import Home from "../components/views/Home.vue";

import SimpleChart from "../components/views/SimpleChart.vue";

const app = createApp({
  data() {
    return {
      message: "Hello Vue 3 and Rails"
    };
  }
});

// import (and use) the components one by one
app.component("Home", Home);
app.component("SimpleChart", SimpleChart);
app.mount("#vue-chart");
