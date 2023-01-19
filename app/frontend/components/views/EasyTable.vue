<template>
  <EasyDataTable :headers="headers" :items="items" alternating />
</template>

<script>
import Vue3EasyDataTable from "vue3-easy-data-table";
import "vue3-easy-data-table/dist/style.css";
export default {
  name: "EasyTable",
  components: { EasyDataTable: Vue3EasyDataTable },
  props: {
    headers: {
      type: Array,
      default: () => []
    },
    items: {
      type: Array,
      default: () => []
    },
    alternating: {
      type: Boolean,
      default: true
    }
  },
  data() {
    return {};
  }
};
</script>
