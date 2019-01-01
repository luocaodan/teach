// mixin
import Issue from '../../../issues/models/issue'

export default {
  data() {
    return {
      projects: [],
      accessMap: {},
      labels: {},
      members: {},
      milestones: {},
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
    const projects = JSON.parse($navbar.dataset.projects);
    const accessMap = {};
    for (let project of projects) {
      accessMap[project.id] = project.access;
    }
    this.accessMap = accessMap;

    for (let project of projects) {
      this.labels[project.id] = project.labels.filter((l) => !['To Do', 'Doing'].includes(l.name));
      this.members[project.id] = project.members;
      this.milestones[project.id] = project.milestones;
      this.projects.push({
        id: project.id,
        name: project.name,
        access: project.access
      });
    }
  },
  methods: {
    milestoneList(issue) {
      return this.milestones[issue.projectId];
    },
    labelList(issue) {
      return this.labels[issue.projectId];
    },
    memberList(issue) {
      return this.members[issue.projectId];
    },
  },
  computed: {
    canEdit() {
      if (!this.issue.projectId) {
        return false;
      }
      let projectId = this.issue.projectId;
      return this.accessMap[projectId] === 'edit';
    }
  },
}