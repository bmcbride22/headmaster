<template>
  <div class="col-span-5 flex flex-col">
    <Listbox as="div" v-model="selected" class="w-56 self-end">
      <div class="relative mt-1">
        <ListboxButton
          class="relative w-full cursor-default rounded-md border border-gray-300 bg-white py-2 pl-3 pr-10 text-left shadow-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500 sm:text-sm"
        >
          <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-1 mt-1 ml-2 mr-4">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path
                class="h-5 w-5 flex-shrink-0 text-gray-500"
                stroke-width="1.5"
                stroke="currentColor"
                aria-hidden="true"
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M11 19L10.8999 18.8499C10.2053 17.808 9.85798 17.287 9.3991 16.9098C8.99286 16.5759 8.52476 16.3254 8.02161 16.1726C7.45325 16 6.82711 16 5.57482 16H4.2C3.07989 16 2.51984 16 2.09202 15.782C1.71569 15.5903 1.40973 15.2843 1.21799 14.908C1 14.4802 1 13.9201 1 12.8V4.2C1 3.07989 1 2.51984 1.21799 2.09202C1.40973 1.71569 1.71569 1.40973 2.09202 1.21799C2.51984 1 3.07989 1 4.2 1H4.6C6.84021 1 7.96031 1 8.81596 1.43597C9.56861 1.81947 10.1805 2.43139 10.564 3.18404C11 4.03968 11 5.15979 11 7.4M11 19V7.4M11 19L11.1001 18.8499C11.7947 17.808 12.142 17.287 12.6009 16.9098C13.0071 16.5759 13.4752 16.3254 13.9784 16.1726C14.5467 16 15.1729 16 16.4252 16H17.8C18.9201 16 19.4802 16 19.908 15.782C20.2843 15.5903 20.5903 15.2843 20.782 14.908C21 14.4802 21 13.9201 21 12.8V4.2C21 3.07989 21 2.51984 20.782 2.09202C20.5903 1.71569 20.2843 1.40973 19.908 1.21799C19.4802 1 18.9201 1 17.8 1H17.4C15.1598 1 14.0397 1 13.184 1.43597C12.4314 1.81947 11.8195 2.43139 11.436 3.18404C11 4.03968 11 5.15979 11 7.4"
              />
            </svg>
          </div>
          <span class="block truncate ml-8 pr-12 text-gray-500">Select Course</span>
          <span class="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-2">
            <ChevronDownIcon class="h-5 w-5 text-gray-400" aria-hidden="true" />
          </span>
        </ListboxButton>

        <transition leave-active-class="transition ease-in duration-100" leave-from-class="opacity-100" leave-to-class="opacity-0">
          <ListboxOptions
            class="absolute z-10 mt-1 max-h-60 w-full overflow-auto rounded-md bg-white py-1 text-base shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none sm:text-sm"
          >
            <ListboxOption
              @click="changeCourseData"
              as="template"
              v-for="course in courses"
              :key="course.id"
              :value="course.id"
              v-slot="{ active, selected }"
            >
              <li :class="[active ? 'text-white bg-indigo-600' : 'text-gray-900', 'relative cursor-default select-none py-2 pl-8 pr-4']">
                <span :class="[selected ? 'font-semibold' : 'font-normal', 'block truncate']">{{ course.title }}</span>

                <span
                  v-if="selected"
                  :class="[active ? 'text-white' : 'text-indigo-600', 'absolute inset-y-0 left-0 flex items-center pl-1.5']"
                >
                  <CheckIcon class="h-5 w-5" aria-hidden="true" />
                </span>
              </li>
            </ListboxOption>
          </ListboxOptions>
        </transition>
      </div>
    </Listbox>
    <Bar id="my-chart-id" :options="chartOptions" :data="chartData" />
  </div>
</template>

<script>
import { Bar } from "vue-chartjs";
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from "chart.js";
import { ref } from "vue";
import { Listbox, ListboxButton, ListboxOption, ListboxOptions } from "@headlessui/vue";
import { CheckIcon, ChevronDownIcon } from "@heroicons/vue/20/solid";

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale);

export default {
  name: "BarChart",
  components: { Bar, Listbox, ListboxButton, ListboxOption, ListboxOptions, CheckIcon, ChevronDownIcon },
  props: {
    propData: {
      type: Object,
      required: true
    },

    courses: {
      type: Array,
      required: true
    },
    current: {
      type: Number,
      required: true
    }
  },
  data() {
    return {
      chartOptions: {
        responsive: true,
        hoverBackgroundColor: "#f97316",
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
          }
        }
      },

      selected: ref(this.courses[this.current]),
      chartData: this.propData[this.current]
    };
  },
  methods: {
    changeCourseData() {
      console.log(this.selected);
      console.log(this.propData);
      this.chartData = this.propData[this.selected];
    }
  }
};
</script>
