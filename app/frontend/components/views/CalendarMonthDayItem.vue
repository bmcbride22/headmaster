<template>
  <li
    class="calendar-day"
    :class="{
      'calendar-day--not-current': !day.isCurrentMonth,
      'calendar-day--today': isToday
    }"
  >
    <span>{{ label }}</span>
  </li>
</template>

<script>
import dayjs from "dayjs";

export default {
  name: "CalendarMonthDayItem",

  props: {
    day: {
      type: Object,
      required: true
    },

    isCurrentMonth: {
      type: Boolean,
      default: false
    },

    isToday: {
      type: Boolean,
      default: false
    }
  },

  computed: {
    label() {
      return dayjs(this.day.date).format("D");
    }
  }
};
</script>

<style scoped>
.calendar-day {
  @apply col-span-1 text-center;
}

.calendar-day > span {
  @apply my-auto;
}

.calendar-day--not-current {
  @apply bg-gray-100 text-gray-300;
}

.calendar-day--today > span {
  @apply text-white bg-orange-500 rounded-full px-2 py-1.5;
}
</style>
