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
import SprintsService from './burndown/services/sprints_service';
import CommonMixin from './shared/components/mixins/common_mixin'
import EchartsOption from './shared/components/mixins/burnEchartsOption'
import DetailSprint from './burndown/components/detail_sprint.vue'
import eventhub from './issues/eventhub'
import Sprint from './burndown/models/sprint'

Vue.use(ElementUI);
Vue.use(MavonEditor);
Vue.component('v-chart', ECharts);

document.addEventListener('DOMContentLoaded', () => {
  const burndownApp = new Vue({
    el: '#burndown-app',
    components: {
      DetailSprint
    },
    mixins: [CommonMixin, EchartsOption],
    data() {
      return {
        milestone: new Sprint(),
        loading: false,
        isShow: false,
      }
    },
    mounted() {
      const $app = document.getElementById('burndown-app');
      const sprintsEndpoint = $app.dataset.sprintsEndpoint;
      this.sprintsService = new SprintsService({
        sprintsEndpoint: sprintsEndpoint
      });

      eventhub.$on('updateSprint', this.updateSprint);

      this.initSprint();
      this.updateBurnInfo();
    },
    methods: {
      initSprint() {
        this.loading = true;
        this.getParams();
        this.sprintsService
          .getSprint(this.milestone.id, this.projectId)
          .then(res => res.data)
          .then(sprint => {
            this.milestone = Sprint.valueOf(sprint);
            this.milestone.isCome = true;
            this.loading = false;
          })
          .catch(e => {
            this.alert('服务器错误');
          })
      },
      updateSprint(update) {
        this.loading = true;
        this.sprintsService
          .updateSprint(this.milestone.id, this.projectId, update)
          .then(res => res.data)
          .then((data) => {
            this.milestone = Sprint.valueOf(data);
            this.milestone.isCome = true;
            this.updateEchartsOption();
            this.loading = false;
          })
          .catch(e => {
            this.alert('服务器错误');
          })
      },
      updateBurnInfo() {
        const params = this.getParams();
        if (!this.milestone.start_date || !this.milestone.due_date) {
          this.isShow = false;
          return;
        }
        this.isShow = true;
        this.loading = true;
        this.issuesService
          .all(params)
          .then(res => res.data)
          .then(data => {
            this.issues = data.issues;
            this.updateEchartsOption();
            this.loading = false;
          })
          .catch(e => {
            this.alert('服务器错误');
          });
      },

      getParams() {
        const pathname = window.location.pathname;
        let list = pathname.split('/');
        let milestoneId = parseInt(list[2]);
        const $navbar = document.getElementById('navbar');
        const projects = JSON.parse($navbar.dataset.projects);
        let milestone = null;
        let projectId = null;
        for (let project of projects) {
          milestone = project.milestones.find(
            (m) => m.id === milestoneId
          );
          if (milestone) {
            projectId = project.id;
            break;
          }
        }
        this.milestone = Sprint.valueOf(milestone);
        this.milestone.isCome = false;
        this.projectId = projectId;
        return {
          milestone: milestone.title,
          project: projectId
        }
      },
    }
  })
});
