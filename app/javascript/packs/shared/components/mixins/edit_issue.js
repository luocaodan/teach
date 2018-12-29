// mixin
import Issue from '../../../issues/models/issue'

export default {
  data() {
    return {
      labels: [],
      projects: [],
      accessMap: {},
      members: [],
      pickerOptions: {
        disabledDate(time) {
          const date = new Date();
          let previousDay = date.setTime(date - 3600 * 1000 * 24);
          return time.getTime() < previousDay;
        },
        shortcuts: [{
          text: '今天',
          onClick(picker) {
            picker.$emit('pick', new Date());
          }
        }, {
          text: '明天',
          onClick(picker) {
            const date = new Date();
            date.setTime(date.getTime() + 3600 * 1000 * 24);
            picker.$emit('pick', date);
          }
        }]
      },
    }
  },
  props: {
    issue: Issue,
  },
  mounted() {
    const $navbar = document.getElementById('navbar');
    this.labels = JSON.parse($navbar.dataset.labels);
    const projects = JSON.parse($navbar.dataset.projects);
    this.projects = projects;
    const accessMap = {};
    for (let project of projects) {
      accessMap[project.id] = project.access;
    }
    this.accessMap = accessMap;
    this.members = JSON.parse($navbar.dataset.members);
  },

}