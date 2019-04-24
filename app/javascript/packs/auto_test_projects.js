import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
  const autoTestProjects = new Vue({
    el: '#auto-test-projects',
  })
})
