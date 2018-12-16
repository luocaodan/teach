import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import App from './demo/components/app.vue'

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#hello',
    render: h => h(App)
  })
})