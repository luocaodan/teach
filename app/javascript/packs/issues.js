import Vue from 'vue/dist/vue.esm'
import IssuesFilter from '../src/issues/components/issues_filter.vue'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import MavonEditor from 'mavon-editor'
import 'mavon-editor/dist/css/index.css'
import IssuesMixin from '../src/shared/components/mixins/issues_mixin'

Vue.use(ElementUI);
Vue.use(MavonEditor);

document.addEventListener('DOMContentLoaded', () => {
  const issuesApp = new Vue({
    el: '#issues-app',
    components: {
      IssuesFilter,
    },
    mixins: [IssuesMixin],
    data() {
      return {

      }
    },
    computed: {
      width() {
        return this.totalWidth - this.asideWidth;
      }
    },
    mounted() {
      this.updateIssues(this.getInitParams());
    },
    created() {
      eventhub.$on('updateParams', this.updateIssues);
      eventhub.$on('updateAsideWidth', this.updateAsideWidth);
      this.asideWidth = 400;
    },
    methods: {
      updateIssuesCallback() {
        // do nothing
      },
      updateAsideWidth(width) {
        let value = this.asideWidth + width;
        let sidebar = document.documentElement.clientWidth - value;
        if (sidebar < 300 || value < 260) {
          return;
        }
        this.asideWidth = value;
      },
      getIssuesList() {
        return this.issues;
      },
      setIssuesList(list) {
        this.issues = list;
      },
      getInitParams() {
        const $navbar = document.getElementById('navbar');
        // projects which current user is a member
        let projects = JSON.parse($navbar.dataset.projects);
        if (!projects.length) {
          return null;
        }
        return {
          state: 'Open',
          project: projects[0].id
        }
      },
      belongsToMe(issue) {
        return true;
      },
      changeLabelIssuesCount(label, value) {
        this.total += value;
      },
      changeLabelIssuesWeight(label, value) {
        this.totalWeight += value;
      }
    }
  })
});