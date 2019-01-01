import Vue from 'vue/dist/vue.esm'
import IssuesList from './issues/components/issues_list.vue'
import Sidebar from './shared/components/sidebar.vue'
import IssuesFilter from './issues/components/issues_filter.vue'
import DetailIssue from './shared/components/detail_issue.vue'
import IssuesService from "./issues/services/issues_service";
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import MavonEditor from 'mavon-editor'
import 'mavon-editor/dist/css/index.css'
import eventhub from './issues/eventhub'
import Issue from './issues/models/issue'
import AlertMixin from './shared/components/mixins/alert'

Vue.use(ElementUI);
Vue.use(MavonEditor);

document.addEventListener('DOMContentLoaded', () => {
  const $navbar = document.getElementById('navbar');

  const $issuesApp = document.getElementById('issues-app');
  const issueApp = new Vue({
    el: $issuesApp,
    components: {
      IssuesList,
      Sidebar,
      IssuesFilter,
      DetailIssue
    },
    mixins: [AlertMixin],
    data() {
      return {
        issues: [],
        detailIndex: 0,
        curIssue: null,
        loading: true,
        issuesEndpoint: $issuesApp.dataset.endpoint,
        // 下方剩余高度
        height: 400,
        // aside 宽度
        asideWidth: 400
      }
    },
    computed: {
      rawIssue() {
        if (this.issues.length === 0) {
          return null;
        }
        return this.issues[this.detailIndex];
      }
    },
    created() {
      this.issuesService = new IssuesService({
        issuesEndpoint: this.issuesEndpoint
      });

      eventhub.$on('reverse', this.reverseList);
      eventhub.$on('sort', this.sortList);
      eventhub.$on('updateParams', this.updateIssues);
      eventhub.$on('updateAsideWidth', this.updateAsideWidth);
      eventhub.$on('updateDetailIndex', this.updateDetailIndex);
      eventhub.$on('addNewIssue', this.addNewIssue);
      eventhub.$on('updateIssue', this.updateIssue);
      // 设置为全局变量 保证编译完成的不同js引用同一个对象
      window.eventhub = eventhub;

      // issuesStore.create();
    },
    mounted() {
      this.updateIssues({});
      window.onresize = () => {
        let navHeight = document.getElementById('navbar').clientHeight;
        let filterHeight = document.getElementById('filter').clientHeight;
        this.height = document.documentElement.clientHeight - navHeight - filterHeight;
      };
      window.onresize();
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
            let list = data;
            this.issues = list.map((issue) => Issue.valueOf(issue));
            if (this.issues.length > 0) {
              this.reDupIssue();
            }
            else {
              this.curIssue = null;
              this.alert('没有结果', 'warning');
            }
            this.loading = false;
          })
          .catch((e) => {
            this.alert('Server error');
            this.alert(e);
            this.loading = false;
          })
      },
      updateAsideWidth(width) {
        let value = this.asideWidth + width;
        let sidebar = document.documentElement.clientWidth - value;
        if (sidebar < 400 || value < 260) {
          return;
        }
        this.asideWidth = value;
      },
      updateDetailIndex(index) {
        this.detailIndex = index;
        this.reDupIssue();
      },
      reDupIssue() {
        this.curIssue = Object.assign(
          new Issue(),
          JSON.parse(JSON.stringify(this.issues[this.detailIndex]))
        );
      },
      addNewIssue(issue) {
        this.loading = true;
        this.issuesService
          .newIssue(issue.toObj())
          .then(res => res.data)
          .then((data) => {
            this.issues.splice(0, 0, Issue.valueOf(data));
            this.updateDetailIndex(0);
            this.loading = false;
          })
          .catch(e => {
            this.alert('Server error');
            this.loading = false;
          })
      },
      updateIssue(update) {
        this.loading = true;
        this.issuesService
          .updateIssue(update)
          .then(res => res.data)
          .then((data) => {
            let updated = Issue.valueOf(data);
            this.issues.splice(this.detailIndex, 1, updated);
            this.updateDetailIndex(this.detailIndex);
            this.loading = false;
          })
          .catch(e => {
            this.alert('Server error');
            this.loading = false;
          })
      },
    }
  })
});