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
        isDrag: false,
        dx: null,
        dy: null,
        tempNode: null,
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
      isDataBack(value) {
        if (value > 0) {
          // dom 渲染完成添加监听器
          this.$nextTick(() => {
            let cards = document.getElementsByClassName('draggable-issue');
            for (let card of cards) {
              this.addDragEvent(card);
            }
          });
        }
      }
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
        // this.issues = null;
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
            this.isDataBack = true;
            this.loading = false;
          })
          .catch(e => {
            this.alert('状态更新失败');
            this.loading = false;
          });
      },
      addDragEvent(card) {
        if (!card.onmousedown) {
          card.onmousedown = this.startDrag(card);
        }
      },
      startDrag(card) {
        return (e) => {
          this.isDrag = true;
          this.cardIndex = card.dataset.index;
          this.cardLabel = card.dataset.label;
          e = e || event;
          e.stopPropagation();
          this.dx = e.layerX;
          this.dy = e.layerY;
          let sx = e.clientX - this.dx;
          let sy = e.clientY - this.dy;
          const width = document.querySelector('.draggable-issue').offsetWidth;
          const stylus = {
            position: 'fixed',
            width: width + 'px',
            zIndex: 10,
            left: sx + 'px',
            top: sy + 'px'
          };
          // 创建临时元素
          console.log('mouse down')
          this.tempNode = card.cloneNode(true);
          Object.assign(this.tempNode.style, stylus);
          console.log('create temp node')
          document.body.appendChild(this.tempNode);
          document.addEventListener('mousemove', this.dragMove);
          document.addEventListener('mouseup', this.endDrag);
          // 显示吸附框
          this.displayBox(card.dataset.label);
          // 水平拖动距离
          this.leftDis = document.getElementById('boards-app').scrollLeft;
        }
      },
      dragMove(e) {
        if (!this.isDrag) {
          return;
        }
        e = e || event;
        e.stopPropagation();
        let mx = e.clientX - this.dx;
        let my = e.clientY - this.dy;
        this.tempNode.style.left = mx + 'px';
        this.tempNode.style.top = my + 'px';
        document.removeEventListener('mousemove', this.dragMove);
        setTimeout(() => {
          document.addEventListener('mousemove', this.dragMove);
        }, 30);
      },
      endDrag(e) {
        if (!this.isDrag) {
          return;
        }
        this.isDrag = false;
        e = e || event;
        e.stopPropagation();
        const x = e.clientX + this.leftDis;
        this.leftDis = null;
        const d = document.querySelector('.el-aside').offsetWidth;
        let label = null;
        if (x > 0.2 * d && x < d * 0.8) {
          label = 'todo';
        } else if (x > 1.2 * d && x < 1.8 * d) {
          label = 'doing';
        } else if (x > 2.2 * d && x < 2.8 * d) {
          label = 'done';
        } else {
          // do nothing
        }

        for (let attr in this.isBox) {
          this.isBox[attr] = false;
        }

        // clear up for gc
        document.body.removeChild(this.tempNode);
        this.tempNode = null;
        this.dx = null;
        this.dy = null;

        if (label) {
          this.updateIssueState(this.cardLabel, this.cardIndex, label);
        }
        this.cardLabel = null;
        this.cardIndex = null;
        document.removeEventListener('mousemove', this.dragMove);
        document.removeEventListener('mouseup', this.endDrag);
      },
      displayBox(label) {
        for (let attr in this.isBox) {
          if (label !== attr) {
            this.isBox[attr] = true;
          }
        }
      }
    },
  })
});
