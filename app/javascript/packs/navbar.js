import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import MavonEditor from 'mavon-editor'
import 'mavon-editor/dist/css/index.css'
import Navbar from '../src/shared/components/navbar.vue'

Vue.use(ElementUI);
Vue.use(MavonEditor);

document.addEventListener('DOMContentLoaded', () => {
  const $navbar = document.getElementById('navbar');
  const navbar = new Vue({
    el: $navbar,
    components: {
      Navbar
    },
  })
});
