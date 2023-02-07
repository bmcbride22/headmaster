import "v-calendar/dist/style.css";
import "./main.scss";

import { createApp } from "vue/dist/vue.esm-bundler";
import { SetupCalendar, Calendar } from "v-calendar";

// import Home from "../components/views/Home.vue";

import CalendarMonth from "../components/views/CalendarMonth.vue";
import BarChart from "../components/views/BarChart.vue";
import DoughnutChart from "../components/views/DoughnutChart.vue";
import DashboardLineChart from "../components/views/DashboardLineChart.vue";
import LineChart from "../components/views/LineChart.vue";
import EasyTable from "../components/views/EasyTable.vue";
import DropDown from "../components/views/DropDown.vue";
import CohortDropDown from "../components/views/CohortDropDown.vue";

const app = createApp({
  data() {
    return {
      message: "Hello Vue 3 and Rails"
    };
  }
});

// import (and use) the components one by one
// app.component("Home", Home);
app.use(SetupCalendar, {});
app.component("DropDown", DropDown);
app.component("CohortDropDown", CohortDropDown);
app.component("CalendarMonth", CalendarMonth);
app.component("Calendar", Calendar);
app.component("EasyTable", EasyTable);
app.component("DashboardLineChart", DashboardLineChart);
app.component("LineChart", LineChart);
app.component("DoughnutChart", DoughnutChart);
app.component("BarChart", BarChart);
app.mount("#vue-chart");
