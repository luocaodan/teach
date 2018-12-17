import Vue from 'vue/dist/vue.esm'
import IssuesList from './issues/components/issues_list.vue'
import Sidebar from './shared/components/sidebar.vue'
import IssuesFilter from './issues/components/issues_filter.vue'
import IssuesService from "./issues/services/issues_service";
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import "./tools/flash"
import eventhub from './issues/eventhub'

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
  const $issuesApp = document.getElementById('issues-app')
  const issueApp = new Vue({
    el: $issuesApp,
    components: {
      IssuesList,
      Sidebar,
      IssuesFilter
    },
    data: {
      issues: [],
      loading: true,
      issuesEndpoint: $issuesApp.dataset.endpoint,
    },
    computed: {
      detailIssue() {
        if (this.issues.length > 0) {
          return this.issues[0];
        }
        else {
          return null;
        }
      }
    },
    created() {
      this.issuesService = new IssuesService({
        issuesEndpoint: this.issuesEndpoint
      });

      eventhub.$on('reverse', this.reverseList);
      eventhub.$on('sort', this.sortList);
      eventhub.$on('updateParams', this.updateIssues);

      // issuesStore.create();
    },
    mounted() {
      this.updateIssues({});
    },
    methods: {
      reverseList() {
        this.issues = this.issues.reverse();
      },
      sortList(field, asc) {
        this.issues = this.issues.sort((a, b) => {
          let cmp = -1;
          if (field === 'weight') {
            if (!b.weight || a.weight && a.weight > b.weight) {
              cmp = -cmp;
            }
          }
          else if (field === 'priority') {
            if (!b.priority || a.priority && a.priority > b.priority) {
              cmp = -cmp;
            }
          }
          else {
            cmp = this.compareDate(a[field], b[field]);
          }
          if (!asc) {
            cmp = -cmp;
          }
          return cmp;
        });
      },
      compareDate(a, b) {
        if (!a) {
          return -1;
        }
        if (!b) {
          return 1;
        }
        let dateA = new Date(Date.parse(a));
        let dateB = new Date(Date.parse(b));
        if (dateA <= dateB) {
          return -1;
        }
        return 1;
      },
      updateIssues(filterParams) {
        this.loading = true;
        this.issuesService
          .all(filterParams)
          .then(res => res.data)
          .then(data => {
            this.issues = data;
            this.loading = false;
          })
          .catch(() => {
            Flash('error');
            this.loading = false;
          })
      }
    }
  })
})