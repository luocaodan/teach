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
import IssuesService from "./issues/services/issues_service";
import IssuesMixin from './shared/components/mixins/issues_mixin'
import eventhub from './issues/eventhub'

Vue.use(ElementUI);
Vue.use(MavonEditor);
Vue.component('v-chart', ECharts);

document.addEventListener('DOMContentLoaded', () => {
  const dailyScrumApp = new Vue({
    el: '#daily-scrum-app',
    components: {

    },
    mixins: [IssuesMixin],
    data() {
      return {
        loading: false,
      }
    },
    methods: {

    }
  })
});
