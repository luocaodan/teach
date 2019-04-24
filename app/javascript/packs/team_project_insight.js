import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import ECharts from 'vue-echarts';
import 'echarts/lib/chart/bar';
import 'echarts/lib/component/tooltip';
import 'echarts/lib/component/title';
import 'echarts/lib/component/toolbox';
import 'echarts/lib/component/dataZoom';
import Insight from '../src/team_project/components/insight.vue'

Vue.use(ElementUI);
Vue.component('v-chart', ECharts);

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#insight-app',
    data() {
      return {}
    },
    components: {
      Insight
    }
  });
});