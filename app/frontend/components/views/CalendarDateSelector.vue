<template>
  <div class="calendar-date-selector">
    <span @click="selectPrevious">
      <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path
          class="text-violet-400"
          d="M12.5 15L7.5 10L12.5 5"
          stroke-width="1.5"
          stroke="currentColor"
          aria-hidden="true"
          stroke-linecap="round"
          stroke-linejoin="round"
        />
      </svg>
    </span>
    <span @click="selectCurrent" class="text-violet-400 text-sm font-bold">Today</span>
    <span @click="selectNext">
      <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path
          class="text-violet-400"
          d="M7.5 15L12.5 10L7.5 5"
          stroke-width="1.5"
          stroke="currentColor"
          aria-hidden="true"
          stroke-linecap="round"
          stroke-linejoin="round"
        />
      </svg>
    </span>
  </div>
</template>

<script>
import dayjs from "dayjs";

export default {
  name: "CalendarModeSelector",

  props: {
    currentDate: {
      type: String,
      required: true
    },

    selectedDate: {
      type: Object,
      required: true
    }
  },

  methods: {
    selectPrevious() {
      const newSelectedDate = dayjs(this.selectedDate).subtract(1, "month");
      this.$emit("dateSelected", newSelectedDate);
    },

    selectCurrent() {
      const newSelectedDate = dayjs(this.currentDate);
      this.$emit("dateSelected", newSelectedDate);
    },

    selectNext() {
      const newSelectedDate = dayjs(this.selectedDate).add(1, "month");
      this.$emit("dateSelected", newSelectedDate);
    }
  }
};
</script>

<style scoped>
.calendar-date-selector {
  @apply flex justify-between w-full mb-2;
}

.calendar-date-selector > * {
  cursor: pointer;
  user-select: none;
}
</style>
