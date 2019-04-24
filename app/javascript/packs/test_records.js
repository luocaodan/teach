import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import MavonEditor from 'mavon-editor'
import 'mavon-editor/dist/css/index.css'
import TestRecords from '../src/auto_tests/components/test_records.vue'

Vue.use(ElementUI);
Vue.use(MavonEditor);

document.addEventListener('DOMContentLoaded', () => {
  const autoTestProjects = new Vue({
    el: '#test-records',
    components: {
      TestRecords
    }
  })
})