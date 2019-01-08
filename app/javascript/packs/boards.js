import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import MavonEditor from 'mavon-editor'
import 'mavon-editor/dist/css/index.css'
import IssuesMixin from './shared/components/mixins/issues_mixin'
import Issue from './issues/models/issue'

Vue.use(ElementUI);
Vue.use(MavonEditor);

document.addEventListener('DOMContentLoaded', () => {
  const boardsApp = new Vue({
    el: '#boards-app',
    components: {},
    data() {
      return {
        detailVisible: false,
        projectId: null,
        milestoneId: null,
        todoIssues: [],
        doingIssues: [],
        doneIssues: [],
        isDataBack: false,
        escCallback: null,
        isNotified: false,
        isBox: {
          'todo': false,
          'doing': false,
          'done': false
        }
      }
    },
    computed: {
      width() {
        return Math.max(this.totalWidth / 4, 280);
      }
    },
    watch: {
      curLabel(value) {
        if (value) {
          this.detailVisible = true;
        } else {
          this.detailVisible = false;
        }
      },
      totalWidth(value) {
        let div = 3;
        if (this.detailVisible) {
          div = 4;
        }
        this.asideWidth = this.totalWidth / div;
      },
      detailVisible(value) {
        if (value) {
          this.asideWidth = this.totalWidth / 4;
          if (!this.isNotified) {
            this.notify('按Esc键关闭问题详情');
            this.isNotified = true;
          }
          // 响应esc键关闭详情页
          this.escCallback = (e) => {
            e = e || event;
            // esc
            if (e.keyCode === 27) {
              this.curLabel = null;
            }
          };
          document.addEventListener('keydown', this.escCallback);
        } else {
          this.asideWidth = this.totalWidth / 3;
          if (this.escCallback) {
            document.removeEventListener('keydown', this.escCallback);
            this.escCallback = null;
          }
        }
      },
    },
    mixins: [IssuesMixin],
    mounted() {
      this.asideWidth = document.documentElement.clientWidth / 3;
      let pathname = window.location.pathname;
      let list = pathname.split('/');
      if (list[1] === 'projects') {
        this.projectId = parseInt(list[2]);
      } else if (list[1] === 'milestones') {
        this.milestoneId = parseInt(list[2]);
      }
      this.updateIssues(this.getInitParams());
      this.divider = false;
      eventhub.$on('displayBox', this.displayBox);
      eventhub.$on('updateIssueState', this.updateIssueState);
    },
    methods: {
      getIssuesEndpoint() {
        const $boardsApp = document.getElementById('boards-app');
        return $boardsApp.dataset.endpoint;
      },
      updateIssuesCallback() {
        this.todoIssues = this.issues.filter((item) => item.state === 'To Do');
        this.doingIssues = this.issues.filter((item) => item.state === 'Doing');
        this.doneIssues = this.issues.filter((item) => item.state === 'Closed');
        this.isDataBack = true;
        this.issues = null;
      },
      getIssuesList(label) {
        if (label === 'todo') {
          return this.todoIssues;
        } else if (label === 'doing') {
          return this.doingIssues;
        } else if (label === 'done') {
          return this.doneIssues;
        } else {
          return null;
        }
      },
      setIssuesList(list, label) {
        if (label === 'todo') {
          this.todoIssues = list;
        } else if (label === 'doing') {
          this.doingIssues = list;
        } else if (label === 'done') {
          this.doneIssues = list;
        } else {
          this.alert('set error');
        }
      },
      getInitParams() {
        // milestone
        let milestone = null;
        let projectId = null;
        if (this.milestoneId) {
          const $navbar = document.getElementById('navbar');
          const projects = JSON.parse($navbar.dataset.projects);
          for (let project of projects) {
            milestone = project.milestones.find(
              (m) => m.id === this.milestoneId
            );
            if (milestone) {
              projectId = project.id;
              break;
            }
          }
          return {
            milestone: milestone.title,
            project: projectId
          }
        }
        // project
        else if (this.projectId) {
          return {project: this.projectId};
        }
      },
      belongsToMe(issue) {
        if (this.milestoneId) {
          return issue.milestone.id === this.milestoneId;
        } else {
          return issue.projectId === this.projectId;
        }
      },
      updateIssueState(fromLabel, fromIndex, toLabel) {
        this.loading = true;
        this.isDataBack = false;
        const stateMap = {
          'todo': 'To Do',
          'doing': 'Doing',
          'done': 'Closed'
        };
        const fromList = this.getIssuesList(fromLabel);
        const issue = fromList[fromIndex];
        const update = {
          id: issue.id,
          project_id: issue.projectId,
          iid: issue.iid,
          attr: 'state',
          value: issue.labels.concat(stateMap[toLabel])
        };
        this.issuesService
          .updateIssue(update)
          .then(res => res.data)
          .then(data => {
            let updated = Issue.valueOf(data);
            let list = this.getIssuesList(toLabel);
            list.splice(0, 0, updated);
            fromList.splice(fromIndex, 1);
            if (this.detailVisible) {
              eventhub.$emit('updateDetailIndex', 0, toLabel);
            }
            this.isDataBack = true;
            this.loading = false;
          })
          .catch(e => {
            this.alert('状态更新失败');
            this.loading = false;
          });
      },
      displayBox(label) {
        for (let attr in this.isBox) {
          if (label === null) {
            this.isBox[attr] = false;
          }
          else if (label !== attr) {
            this.isBox[attr] = true;
          }
        }
      }
    },
  })
});
