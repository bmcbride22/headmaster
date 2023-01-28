<template>
  <div class="calendar-month">
    <div class="calendar-month-header">
      <div class="calendar-month-selection">
        <CalendarDateSelector :current-date="today" :selected-date="selectedDate" @dateSelected="selectDate" />
      </div>
      <div class="calendar-month-title">
        <CalendarDateIndicator :selected-date="selectedDate" class="calendar-month-header-selected-month" />
      </div>
    </div>

    <CalendarWeekdays />

    <ol class="days-grid">
      <CalendarMonthDayItem v-for="day in days" :key="day.date" :day="day" :is-today="day.date === today" />
    </ol>
  </div>
</template>

<script>
import dayjs from "dayjs";
import weekday from "dayjs/plugin/weekday";
import weekOfYear from "dayjs/plugin/weekOfYear";
import CalendarMonthDayItem from "./CalendarMonthDayItem.vue";
import CalendarDateIndicator from "./CalendarDateIndicator.vue";
import CalendarDateSelector from "./CalendarDateSelector.vue";
import CalendarWeekdays from "./CalendarWeekdays.vue";

dayjs.extend(weekday);
dayjs.extend(weekOfYear);

export default {
  name: "CalendarMonth",

  components: {
    CalendarMonthDayItem,
    CalendarDateIndicator,
    CalendarDateSelector,
    CalendarWeekdays
  },

  data() {
    return {
      selectedDate: dayjs()
    };
  },

  computed: {
    days() {
      return [...this.previousMonthDays, ...this.currentMonthDays, ...this.nextMonthDays];
    },

    today() {
      return dayjs().format("YYYY-MM-DD");
    },

    month() {
      return Number(this.selectedDate.format("M"));
    },

    year() {
      return Number(this.selectedDate.format("YYYY"));
    },

    numberOfDaysInMonth() {
      return dayjs(this.selectedDate).daysInMonth();
    },

    currentMonthDays() {
      return [...Array(this.numberOfDaysInMonth)].map((day, index) => {
        return {
          date: dayjs(`${this.year}-${this.month}-${index + 1}`).format("YYYY-MM-DD"),
          isCurrentMonth: true
        };
      });
    },

    previousMonthDays() {
      const firstDayOfTheMonthWeekday = this.getWeekday(this.currentMonthDays[0].date);
      const previousMonth = dayjs(`${this.year}-${this.month}-01`).subtract(1, "month");

      // Cover first day of the month being sunday (firstDayOfTheMonthWeekday === 0)
      const visibleNumberOfDaysFromPreviousMonth = firstDayOfTheMonthWeekday ? firstDayOfTheMonthWeekday - 1 : 6;

      const previousMonthLastMondayDayOfMonth = dayjs(this.currentMonthDays[0].date)
        .subtract(visibleNumberOfDaysFromPreviousMonth, "day")
        .date();

      return [...Array(visibleNumberOfDaysFromPreviousMonth)].map((day, index) => {
        return {
          date: dayjs(`${previousMonth.year()}-${previousMonth.month() + 1}-${previousMonthLastMondayDayOfMonth + index}`).format(
            "YYYY-MM-DD"
          ),
          isCurrentMonth: false
        };
      });
    },

    nextMonthDays() {
      const lastDayOfTheMonthWeekday = this.getWeekday(`${this.year}-${this.month}-${this.currentMonthDays.length}`);

      const nextMonth = dayjs(`${this.year}-${this.month}-01`).add(1, "month");

      const visibleNumberOfDaysFromNextMonth = lastDayOfTheMonthWeekday ? 7 - lastDayOfTheMonthWeekday : lastDayOfTheMonthWeekday;

      return [...Array(visibleNumberOfDaysFromNextMonth)].map((day, index) => {
        return {
          date: dayjs(`${nextMonth.year()}-${nextMonth.month() + 1}-${index + 1}`).format("YYYY-MM-DD"),
          isCurrentMonth: false
        };
      });
    }
  },

  methods: {
    getWeekday(date) {
      return dayjs(date).weekday();
    },

    selectDate(newSelectedDate) {
      this.selectedDate = newSelectedDate;
    }
  }
};
</script>

<style scoped>
ol,
li {
  padding: 0;
  margin: 0;
  list-style: none;
}

.calendar-month-header {
  @apply flex flex-col w-full p-2;
}
.calendar-month {
  @apply col-span-2 bg-white border-2 border-gray-200 rounded-lg  flex flex-col h-full w-full shadow-md shadow-gray-300 p-4 m-1;
}

.day-of-week {
  @apply py-2;
}
.day-of-week,
.days-grid {
  @apply grid grid-cols-7;
}

.days-grid {
  @apply h-full mb-1;
}
</style>
