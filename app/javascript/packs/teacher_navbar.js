import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import Navbar from '../src/shared/components/teacher_navbar.vue'

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
  const $navbar = document.getElementById('navbar');
  const navbar = new Vue({
    el: $navbar,
    components: {
      Navbar
    },
  })
});
