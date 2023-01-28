<template>
  <div class="calendar-date-indicator">{{ selectedMonth }}</div>
</template>

<script>
export default {
  props: {
    selectedDate: {
      type: Object,
      required: true
    }
  },

  computed: {
    selectedMonth() {
      return this.selectedDate.format("MMMM YYYY");
    }
  }
};
</script>

<style scoped>
.calendar-date-indicator {
  @apply text-base text-center font-semibold text-violet-700;
}
</style>
