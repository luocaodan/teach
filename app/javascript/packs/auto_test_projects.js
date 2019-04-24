import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import CommonMixin from '../src/shared/components/mixins/common_mixin'

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
  const autoTestProjects = new Vue({
    el: '#auto-test-projects',
    mixins: [CommonMixin],

  })
})
