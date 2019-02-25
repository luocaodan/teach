import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import ECharts from 'vue-echarts';
import 'echarts/lib/chart/line';
import 'echarts/lib/component/tooltip';
import 'echarts/lib/component/title';
import 'echarts/lib/component/toolbox';
import 'echarts/lib/component/legend';
import MavonEditor from 'mavon-editor'
import 'mavon-editor/dist/css/index.css'
import CommonMixin from './shared/components/mixins/common_mixin'

Vue.use(ElementUI);
Vue.use(MavonEditor);
Vue.component('v-chart', ECharts);

document.addEventListener('DOMContentLoaded', () => {
  const newBlogApp = new Vue({
    el: '#new-blog-app',
    mixins: [CommonMixin],
    data() {

    },
  });
});