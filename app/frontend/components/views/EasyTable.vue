<template>
  <div>
    <div class="flex flex-row-reverse items-center justify-between mb-2">
      <div class="relative items-center">
        <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-1">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path
              class="mr-4 h-6 w-6 flex-shrink-0 text-violet-700"
              d="M21 21L16.65 16.65M19 11C19 15.4183 15.4183 19 11 19C6.58172 19 3
            15.4183 3 11C3 6.58172 6.58172 3 11 3C15.4183 3 19 6.58172 19 11Z"
              stroke-width="1.5"
              stroke="currentColor"
              aria-hidden="true"
              stroke-linecap="round"
              stroke-linejoin="round"
            />
          </svg>
        </div>
        <input
          class="bg-violet-50 placeholder:text-violet-700 placeholder:text-base placeholder:font-semi-light focus:outline-violet-700 rounded-md py-2 pl-10"
          type="text"
          placeholder="Search"
          v-model="searchValue"
        />
      </div>
    </div>

    <EasyDataTable
      :headers="headers"
      :items="items"
      alternating
      @clickRow="showStudent"
      :search-field="searchField"
      :search-value="searchValue"
    />
  </div>
</template>

<script>
import Vue3EasyDataTable from "vue3-easy-data-table";
import { ref } from "vue";
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
    return {
      searchField: ref("student_name"),
      searchValue: ref("")
    };
  },
  methods: {
    showStudent(row) {
      window.location.href = `/student_profiles/${row.student_id}`;
    }
  }
};
</script>

<style>
.vue3-easy-data-table {
  @apply w-full overflow-x-auto  rounded-lg shadow bg-white ring-1 ring-slate-200;
}

/* Table container */
.vue3-easy-data-table__main {
  @apply overflow-x-auto;
}

/* Scrollbar styles */
.vue3-easy-data-table__main::-webkit-scrollbar {
  @apply h-[9px] bg-transparent cursor-pointer;
}

.vue3-easy-data-table__main::-webkit-scrollbar-track {
  @apply bg-transparent;
}
.vue3-easy-data-table__main::-webkit-scrollbar-thumb {
  @apply bg-gray-50 hover:bg-gray-50 transition  cursor-pointer;
}

/* Border cell */
.vue3-easy-data-table .border-cell tr td,
.vue3-easy-data-table .border-cell tr th {
  @apply last:border-none border-r border-gray-200;
}

.vue3-easy-data-table .border-cell tr td.can-expand,
.vue3-easy-data-table .border-cell tr th {
  @apply border-r-0;
}

/* Table */
.vue3-easy-data-table table {
  width: 100%;
}

/* Tableheader row */
.vue3-easy-data-table__header tr {
  @apply bg-violet-100 border-b py-6;
}

/* Table header th tag */
.vue3-easy-data-table__header tr th {
  @apply text-left p-4 font-medium capitalize text-sm relative whitespace-nowrap select-none;
}

/* Fixed header */

.vue3-easy-data-table__main.fixed-header.show-shadow.table-fixed .shadow {
  @apply bg-white border-r;
}

/* table head sort icons */
/* None */
.vue3-easy-data-table__header tr th.sortable.none .sortType-icon {
  @apply border  hover:bg-violet-50  ml-3 border-orange-500 font-bold inline-block p-1 -rotate-45
transition  cursor-pointer;
}
/* Asce */
.vue3-easy-data-table__header tr th.sortable.asc .sortType-icon {
  @apply border-t-2 border-r-2 ml-3 border-orange-500  inline-block p-1 -rotate-45
transition  cursor-pointer;
}
/* Desc */
.vue3-easy-data-table__header tr th.sortable.desc .sortType-icon {
  @apply border-b-2 border-l-2 ml-3 border-orange-500 inline-block p-1 -rotate-45
transition  cursor-pointer;
}
/* make sortable headers use cursor pointer */
.vue3-easy-data-table__header tr th.sortable {
  @apply cursor-pointer;
}

/* Table body td tag */
.vue3-easy-data-table__body tr td {
  @apply border-b;
}
.vue3-easy-data-table__body tr .shadow {
  @apply font-semibold;
}
.vue3-easy-data-table__body tr td {
  @apply p-4 py-5 text-sm font-light;
}
/* Table body tr */
.vue3-easy-data-table__body.row-alternation tr {
  @apply even:bg-violet-50  even:text-violet-900 hover:bg-violet-100  transition;
}

/* Expand slot */
.vue3-easy-data-table__body tr td.expand {
  @apply px-3 py-1;
}

/* Expand Icon  */
.expand-icon {
  @apply border-t border-r border-gray-500 inline-block p-1 -rotate-45
transition  cursor-pointer;
}
.expand-icon.expanding {
  @apply rotate-[225deg] border-violet-700  bg-violet-50;
}

/* Footer */

.vue3-easy-data-table__footer {
  @apply hidden
	/* flex flex-col items-start gap-5 lg:flex-row lg:items-center w-full px-6 py-5 text-sm border-t; */;
}
/* Rows per page */

.pagination__rows-per-page {
  @apply flex text-sm capitalize gap-x-3;
}

/* Row selector */
.easy-data-table__rows-selector {
  @apply flex relative;
}

/* Select input box */
.rows-input__wrapper {
  @apply border-b border-gray-100 flex gap-x-2 items-center justify-between  pb-1 px-3 cursor-pointer;
}
.rows-input__wrapper .triangle {
  @apply inline-block h-2 w-2 border-4 border-transparent border-t-violet-700;
}
/* Selction dropdown */
.vue3-easy-data-table__footer .select-items {
  @apply hidden bg-white shadow-md rounded-md divide-y overflow-hidden transition;
}

.vue3-easy-data-table__footer .select-items.show {
  @apply block absolute -top-[120px];
}

/* Select items inside dropdown */
.vue3-easy-data-table__footer .select-items.show li {
  @apply px-2 py-1 cursor-pointer hover:bg-violet-50;
}
.vue3-easy-data-table__footer .select-items.show li.selected {
  @apply bg-violet-50  text-white;
}

/* Paging buttons */
.buttons-pagination {
  @apply flex gap-x-2 items-center;
}
/* Button items */
.buttons-pagination .item.button {
  @apply flex items-center justify-center h-7 w-7 border rounded-full cursor-pointer transition text-xs;
}
.buttons-pagination .item.button.active {
  @apply bg-violet-800 text-white border-violet-800;
}

/* Page index */
.pagination__items-index {
  @apply grow;
}

/* Paging arrows */
.previous-page__click-button,
.next-page__click-button {
  @apply my-0 mx-1 cursor-pointer hidden lg:block;
}
.previous-page__click-button .arrow,
.next-page__click-button .arrow {
  @apply inline-block w-2 h-2 border-t-2 border-l-2 border-gray-100;
}
.previous-page__click-button .arrow.arrow-left,
.next-page__click-button .arrow.arrow-left {
  @apply rotate-[135deg];
}

.previous-page__click-button .arrow.arrow-right,
.next-page__click-button .arrow.arrow-right {
  @apply rotate-[-45deg];
}

/* Check box */
.easy-checkbox {
  @apply relative w-5 h-5 my-0;
}
.easy-checkbox label {
  @apply cursor-pointer before:absolute before:inset-y-0
before:w-5 before:h-5;
}

/* Table message */
.vue3-easy-data-table__message {
  @apply text-center py-10;
}

/* Table default loader */
.loading-entity {
  @apply cursor-wait text-center py-10 flex flex-col gap-5 items-center after:content-['Loading...'] after:text-slate-500;
}
.lds-ring {
  @apply inline-block relative h-16 w-16;
}
.lds-ring div {
  @apply block absolute w-[80%] h-[80%] m-2 border-4 border-t-transparent rounded-full
border-violet-700 animate-spin;
}
</style>
