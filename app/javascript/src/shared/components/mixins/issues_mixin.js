import AlertMixin from "./alert";
import eventhub from "../../../issues/eventhub";
import IssuesService from "../../../issues/services/issues_service";
import Issue from "../../../issues/models/issue";
import IssuesList from '../../../issues/components/issues_list.vue'
import Sidebar from '../sidebar.vue'
import DetailIssue from '../detail_issue.vue'

export default {
  components: {
    IssuesList,
    Sidebar,
    DetailIssue
  },
  mixins: [AlertMixin],
  data() {
    return {
      issues: [],
      // next page
      nextPage: 2,
      // total issue
      total: 0,
      totalWeight: 0,
      // to do
      todoTotal: 0,
      todoTotalWeight: 0,
      // doing
      doingTotal: 0,
      doingTotalWeight: 0,
      // done
      doneTotal: 0,
      doneTotalWeight: 0,
      detailIndex: 0,
      curIssue: null,
      curLabel: null,
      loading: false,
      // 下方剩余高度
      height: 0,
      // aside 宽度
      asideWidth: 0,
      totalWidth: document.documentElement.clientWidth,
      divider: true
    }
  },
  computed: {
    rawIssue() {
      let list = this.getIssuesList(this.curLabel);
      if (list.length === 0) {
        return null;
      }
      return list[this.detailIndex];
    },
  },
  created() {
    eventhub.$on('reverse', this.reverseList);
    eventhub.$on('sort', this.sortList);
    eventhub.$on('addNewIssue', this.addNewIssue);
    eventhub.$on('updateIssue', this.updateIssue);
    eventhub.$on('updateDetailIndex', this.updateDetailIndex);
    eventhub.$on('moreIssues', this.moreIssues);
    // 设置为全局变量 保证编译完成的不同js引用同一个对象
    window.eventhub = eventhub;
  },
  mounted() {
    this.issuesService = new IssuesService({
      issuesEndpoint: this.getIssuesEndpoint()
    });
    window.onresize = () => {
      this.$nextTick(() => {
        const $filter = document.getElementById('filter');
        let filterHeight = 0;
        if ($filter) {
          filterHeight = $filter.clientHeight;
        }
        const scrollHeight = this.getScrollHeight();
        let diff = filterHeight + scrollHeight;
        this.height = this.$el.clientHeight - diff;
        this.totalWidth = document.documentElement.clientWidth;
      })
    };
    window.onresize();
  },
  methods: {
    noImpl() {
      this.alert('未实现');
    },
    getIssuesEndpoint() {
      this.noImpl();
    },
    updateIssuesCallback() {
      this.noImpl();
    },
    getIssuesList(label) {
      this.noImpl();
    },
    setIssuesList(list, label) {
      this.noImpl();
    },
    getInitParams() {
      this.noImpl();
    },
    belongsToMe(issue) {
      this.noImpl();
    },
    reverseList(label) {
      let list = this.getIssuesList(label);
      this.setIssuesList(list.reverse(), label);
    },
    issueComparator(field, asc) {
      return (a, b) => {
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
      };
    },
    sortList(field, asc, label) {
      let list = this.getIssuesList(label);
      this.setIssuesList(list.sort(this.issueComparator(field, asc)), label);
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
    updateIssues(filterParams, isMore = false) {
      if (!filterParams) {
        this.warn('没有结果');
        return;
      }
      this.filterParams = filterParams;
      // 处理分页
      if (isMore) {
        filterParams['page'] = this.nextPage;
      }
      else {
        filterParams['page'] = 1;
      }
      if (!isMore) {
        this.loading = true;
      }
      this.issuesService
        .all(filterParams)
        .then(res => res.data)
        .then(data => {
          const issues = data.issues.map((issue) => Issue.valueOf(issue));
          if (isMore) {
            this.issues = this.issues.concat(issues);
          }
          else {
            this.issues = issues;
          }
          this.total = data['total'];
          this.totalWeight = data['total_weight'];
          this.todoTotal = data['todo_total'];
          this.todoTotalWeight = data['todo_total_weight'];
          this.doingTotal = data['doing_total'];
          this.doingTotalWeight = data['doing_total_weight'];
          this.doneTotal = data['done_total'];
          this.doneTotalWeight = data['done_total_weight'];
          this.nextPage = data['next'];
          if (this.issues.length === 0) {
            this.warn('没有结果');
          }
          this.updateIssuesCallback();
          eventhub.$emit('updateDetailIndex', 0);
          this.loading = false;
        })
        .catch((e) => {
          this.alert('服务器错误');
          this.loading = false;
        })
    },
    moreIssues() {
      if (!this.nextPage) {
        return;
      }
      this.updateIssues(this.filterParams, true);
    },
    updateDetailIndex(index, label) {
      this.detailIndex = index;
      this.curLabel = label ? label : null;
      this.reDupIssue();
    },
    reDupIssue() {
      let list = this.getIssuesList(this.curLabel);
      if (!list || list.length === 0) {
        this.curIssue = null;
        return;
      }
      this.curIssue = Object.assign(
        new Issue(),
        JSON.parse(JSON.stringify(list[this.detailIndex]))
      );
    },
    addNewIssue(issue, label = 'todo') {
      this.loading = true;
      this.issuesService
        .newIssue(issue.toObj())
        .then(res => res.data)
        .then((data) => {
          let issue = Issue.valueOf(data);
          if (!this.belongsToMe(issue)) {
            this.success('创建成功');
            this.loading = false;
            return;
          }
          let list = this.getIssuesList(label);
          list.splice(0, 0, issue);
          this.changeLabelIssuesCount(label, +1);
          if (issue.weight) {
            this.changeLabelIssuesWeight(label, +issue.weight);
          }
          eventhub.$emit('updateDetailIndex', 0, label);
          this.loading = false;
        })
        .catch(e => {
          this.alert('创建问题失败');
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
          let list = this.getIssuesList(this.curLabel);
          list.splice(this.detailIndex, 1, updated);
          eventhub.$emit('updateDetailIndex', this.detailIndex, this.curLabel);
          this.loading = false;
        })
        .catch(e => {
          this.alert('更新失败');
          this.loading = false;
        })
    },
    getScrollHeight() {
      let P = document.createElement('p');
      let styles = {
        width: '100px',
        height: '100px',
        overflowX: 'scroll',
      };

      for (let i in styles){
        P.style[i] = styles[i];
      }
      document.body.appendChild(P);
      let scrollbarHeight = P.offsetHeight - P.clientHeight;
      document.body.removeChild(P);

      return scrollbarHeight;
    },
  }
}