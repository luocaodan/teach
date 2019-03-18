import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import CommonMixin from './shared/components/mixins/common_mixin'
import TestRecords from './auto_tests/components/test_records.vue'

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
  const autoTestProjects = new Vue({
    el: '#test-records',
    mixins: [CommonMixin],
    components: {
      TestRecords
    }
  })
})