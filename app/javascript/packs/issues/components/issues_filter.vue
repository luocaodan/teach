<template>
  <div class="filter">
    <span>
    <el-dropdown size="small" @command="selectProject">
      <span>
        项目： {{ currentPN }}
        <i class="el-icon-arrow-down el-icon--right"></i>
      </span>
      <el-dropdown-menu slot="dropdown">
        <el-dropdown-item command="all">所有</el-dropdown-item>
        <el-dropdown-item v-for="(project, index) in projects" :key="index" :command="project.id+','+project.name">
          {{ project.name }}
        </el-dropdown-item>
      </el-dropdown-menu>
    </el-dropdown>
    </span>
    <span>
      <el-dropdown size="small" @command="selectLabel">
        <span>
          标签： {{ text(currentL) }}
          <i class="el-icon-arrow-down el-icon--right"></i>
        </span>
        <el-dropdown-menu slot="dropdown">
          <el-dropdown-item command="all">所有</el-dropdown-item>
          <el-dropdown-item v-for="(label, index) in labels" :key="index" :command="label.name">
            {{ label.name }}
          </el-dropdown-item>
        </el-dropdown-menu>
      </el-dropdown>
    </span>
    <span>
      <el-dropdown size="small" @command="selectState">
        <span>
          状态： {{ text(currentL) }}
          <i class="el-icon-arrow-down el-icon--right"></i>
        </span>
        <el-dropdown-menu slot="dropdown">
          <el-dropdown-item command="all">所有</el-dropdown-item>
          <el-dropdown-item v-for="(state, index) in states" :key="index" :command="state">
            {{ state }}
          </el-dropdown-item>
        </el-dropdown-menu>
      </el-dropdown>
    </span>
    <span>
      <el-dropdown size="small" @command="selectAssignee">
        <span>
          经办人： {{ currentMN }}
          <i class="el-icon-arrow-down el-icon--right"></i>
        </span>
        <el-dropdown-menu slot="dropdown">
          <el-dropdown-item command="all">所有</el-dropdown-item>
          <el-dropdown-item v-for="(assignee, index) in members" :key="index" :command="assignee.id+','+assignee.name">
            {{ assignee.name }}
          </el-dropdown-item>
        </el-dropdown-menu>
      </el-dropdown>
    </span>
  </div>
</template>

<script>
  import eventhub from '../eventhub'

  export default {
    data: function () {
      return {
        projects: [],
        labels: [],
        members: [],
        states: [
          'Open',
          'Closed',
          'To Do',
          'Doing'
        ],
        currentP: 'all',
        currentPN: '',
        currentL: 'all',
        currentM: 'all',
        currentMN: '',
        currentS: 'all'
      }
    },
    computed: {
      filterParams() {
        const params = {};
        const labels = [];
        if (this.currentP !== 'all') {
          params['project'] = this.currentP;
        }
        if (this.currentL !== 'all') {
           labels.push(this.currentL);
        }
        if (this.currentM !== 'all') {
          params['assignee_id'] = this.currentM;
        }
        if (this.currentS !== 'all') {
          if (['Open', 'Closed'].includes(this.currentS)) {
            params['state'] = this.currentS === 'Open' ? 'opened' : 'closed';
          }
          else {
            labels.push(this.currentS);
          }
        }
        if (labels.length) {
          params['labels'] = labels.join(',');
        }
        return params;
      }
    },
    mounted() {
      const $filter = document.getElementById('filter');
      this.projects = JSON.parse($filter.dataset.projects);
      this.labels = JSON.parse($filter.dataset.labels);
      this.members = JSON.parse($filter.dataset.members);
    },
    methods: {
      text(str) {
        if (str === 'all') {
          return '所有';
        }
        return str;
      },
      selectProject(str) {
        let list = str.split(',');
        let project_id = list[0];
        let project_name = list[1];
        console.log(project_id)
        if (project_id === this.currentP) {
          return;
        }
        this.currentP = project_id;
        this.currentPN = project_name;
        this.update();
      },
      selectLabel(label_name) {
        if (label_name === this.currentL) {
          return;
        }
        this.currentL = label_name;
        this.update();
      },
      selectState(state) {
        if (state === this.currentS) {
          return;
        }
        this.currentS = state;
        this.update();
      },
      selectAssignee(str) {
        let list = str.split(',');
        let user_id = list[0];
        let user_name = list[1];
        if (user_id === this.currentM) {
          return;
        }
        this.currentM = user_id;
        this.currentMN = user_name;
        this.update();
      },
      update() {
        eventhub.$emit('updateParams', this.filterParams);
      }
    }
  }
</script>

<style scoped>
  .filter {
    border: 1px solid #e5e5e5;
    background-color: #fafafa;
    padding: 10px 30px;
  }
  .filter > span {
    margin-right: 20px;
  }
</style>