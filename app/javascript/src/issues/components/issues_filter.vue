<template>
  <div class="filter">
    <span>
    <el-dropdown size="small" @command="selectProject">
      <span>
        项目： {{ currentPN }}
        <i class="el-icon-arrow-down el-icon--right"></i>
      </span>
      <el-dropdown-menu slot="dropdown">
        <el-dropdown-item v-for="(project, index) in projects"
                          :key="index" :command="index">
          {{ project.name_with_namespace }}
        </el-dropdown-item>
      </el-dropdown-menu>
    </el-dropdown>
    </span>
    <span>
      <el-dropdown size="small" @command="selectLabel">
        <span>
          标签： {{ currentLN }}
          <i class="el-icon-arrow-down el-icon--right"></i>
        </span>
        <el-dropdown-menu slot="dropdown">
          <el-dropdown-item command="all">所有</el-dropdown-item>
          <el-dropdown-item v-for="(label, index) in labels"
                            :key="index" :command="index">
            {{ label.name }}
          </el-dropdown-item>
        </el-dropdown-menu>
      </el-dropdown>
    </span>
    <span>
      <el-dropdown size="small" @command="selectState">
        <span>
          状态： {{ currentSN }}
          <i class="el-icon-arrow-down el-icon--right"></i>
        </span>
        <el-dropdown-menu slot="dropdown">
          <el-dropdown-item command="all">所有</el-dropdown-item>
          <el-dropdown-item v-for="(state, index) in states"
                            :key="index" :command="state">
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
          <el-dropdown-item v-for="(assignee, index) in members"
                            :key="index" :command="index">
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
        states: [
          'Open',
          'To Do',
          'Doing',
          'Closed'
        ],
        // projects 数组索引
        currentP: null,
        // labels 数组索引
        currentL: 'all',
        // members 数组索引
        currentM: 'all',
        // issues 状态
        currentS: 'Open'
      }
    },
    computed: {
      labels() {
        if (this.currentP === null) {
          return [];
        }
        const labels = this.projects[this.currentP].labels;
        return labels.filter((l) => !['To Do', 'Doing'].includes(l.name));
      },
      members() {
        if (this.currentP === null) {
          return [];
        }
        return this.projects[this.currentP].members;
      },
      currentPN() {
        if (this.currentP === null) {
          return '暂无项目';
        }
        return this.projects[this.currentP].name_with_namespace;
      },
      currentLN() {
        if (this.currentL === 'all') {
          return '所有'
        }
        return this.labels[this.currentL].name;
      },
      currentMN() {
        if (this.currentM === 'all') {
          return '所有'
        }
        return this.members[this.currentM].name;
      },
      currentSN() {
        if (this.currentS === 'all') {
          return '所有'
        }
        return this.currentS;
      },
      filterParams() {
        const params = {};
        params['project'] = this.projects[this.currentP].id;
        if (this.currentL !== 'all') {
          params['labels'] = this.labels[this.currentL].name;
        }
        if (this.currentM !== 'all') {
          params['assignee_id'] = this.members[this.currentM].id;
        }
        if (this.currentS !== 'all') {
          params['state'] = this.currentS;
        }
        return params;
      }
    },
    mounted() {
      const $navbar = document.getElementById('navbar');
      // projects which current user is a member
      this.projects = JSON.parse($navbar.dataset.projects);
      // 默认选择第一个项目
      if (!this.projects.length) {
        this.currentP = null;
      }
      else {
        this.currentP = 0;
      }
    },
    methods: {
      selectProject(projectIndex) {
        if (projectIndex === this.currentP) {
          return;
        }
        this.currentP = projectIndex;
        this.currentL = 'all';
        this.currentM = 'all';
        this.currentS = 'Open';
        this.update();
      },
      selectLabel(labelIndex) {
        if (labelIndex === this.currentL) {
          return;
        }
        this.currentL = labelIndex;
        this.update();
      },
      selectState(state) {
        if (state === this.currentS) {
          return;
        }
        this.currentS = state;
        this.update();
      },
      selectAssignee(memberIndex) {
        if (memberIndex === this.currentM) {
          return;
        }
        this.currentM = memberIndex;
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