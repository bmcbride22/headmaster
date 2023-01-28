<template>
  <ol class="day-of-week">
    <li v-for="weekday in weekdays" :key="weekday">{{ weekday }}</li>
  </ol>
</template>

<script>
const WEEKDAYS = ["M", "T", "W", "Th", "F", "Sa", "Su"];

export default {
  name: "CalendarWeekdays",

  computed: {
    weekdays() {
      return WEEKDAYS;
    }
  }
};
</script>

<style scoped>
.day-of-week {
  @apply grid grid-cols-7 gap-1;
}

.day-of-week > * {
  @apply text-center text-violet-700 text-sm col-span-1;
}
</style>
