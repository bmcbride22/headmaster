<template>
  <div>
    <h1>Hello</h1>
    <SimpleChart />
  </div>
</template>

<script>
export default {
  name: "Home",
  props: {
    btnText: { type: String, value: "Hello" }
  },
  data() {
    return {
      // Component's initial data
      // btnText: "hello",
      dir: "frontend/components/views/Home.vue"
    };
  },
  mounted() {
    console.log("hello from VUE");
  },
  methods: {
    sayHello() {
      console.log("You clicked a Vue button 🎉");
    }
  }
};
</script>
