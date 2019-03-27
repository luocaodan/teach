<template>
  <div class="navbar clearFloat">
    <el-menu
      :default-active="kanban"
      mode="horizontal"
      @select="handleSelect"
      background-color="#545c64"
      text-color="#fff"
      active-text-color="#ffd04b">
      <el-submenu index="1">
        <template slot="title">项目看板</template>
        <el-menu-item v-for="(project, index) in projects" :key="index" :index="'1-' + project.id">
          {{ project.name }}
        </el-menu-item>
      </el-submenu>

      <el-submenu index="2">
        <template slot="title">冲刺</template>
        <el-submenu
          v-for="(milestone, index) in milestones"
          :key="index"
          :index="'2-' + index">
          <template slot="title">{{ milestone.title }}</template>
          <el-menu-item
            :index="'2-' + milestone.project_id + '-' + milestone.id + '-kanban'">
            看板
          </el-menu-item>
          <el-menu-item
            :index="'2-' + milestone.project_id + '-' + milestone.id + '-burndown'">
            冲刺详情
          </el-menu-item>
        </el-submenu>
        <el-submenu index="2-new" v-if="this.projects.length">
          <template slot="title">新建冲刺</template>
          <el-menu-item v-for="(project, index) in projects" :key="index" :index="'2-new-' + project.id">
            {{ project.name }}
          </el-menu-item>
        </el-submenu>
      </el-submenu>
      <el-menu-item index="3">
        问题
      </el-menu-item>

      <el-menu-item index="4">
        博客
      </el-menu-item>

      <el-menu-item index="5">
        我的班级
      </el-menu-item>

      <el-menu-item index="6">
        GitLab
        <i class="iconfont icon-link"></i>
      </el-menu-item>


      <el-submenu index="7" style="float: right">
        <template slot="title">新建问题</template>
        <el-menu-item v-for="(project, index) in projects" :key="index" :index="'7-' + project.id">
          {{ project.name }}
        </el-menu-item>
      </el-submenu>

    </el-menu>

    <el-dialog
      title="新建问题"
      top="50px"
      :visible.sync="dialogVisible"
      width="80%">
      <!--:before-close="handleClose">-->
      <new-issue ref="newIssue" :issue="newIssue"></new-issue>
      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="addIssue('newIssueForm')">确 定</el-button>
      </span>
    </el-dialog>

    <!--<el-dialog-->
    <!--title="新建冲刺"-->
    <!--top="50px"-->
    <!--:visible.sync="milestoneDialogVisible"-->
    <!--width="80%">-->
    <!--<new-milestone ref="newMilestone" :milestone="newMilestone" :milestones="milestones"></new-milestone>-->
    <!--<span slot="footer" class="dialog-footer">-->
    <!--<el-button @click="milestoneDialogVisible = false">取 消</el-button>-->
    <!--<el-button type="primary" @click="addMilestone('newMilestoneForm')">确 定</el-button>-->
    <!--</span>-->
    <!--</el-dialog>-->
  </div>
</template>
<script>
  import NewIssue from './new_issue.vue'
  import NewMilestone from './new_milestone.vue'
  import Issue from '../../issues/models/issue'

  export default {
    components: {
      NewIssue,
      NewMilestone
    },
    data() {
      return {
        kanban: '1',
        issues: '2',
        gitlab: '3',
        projects: [],
        milestones: [],
        gitlabHost: '',
        dialogVisible: false,
        newIssue: new Issue(),
        // newMilestone: {},
      };
    },
    mounted() {
      const navbar = document.getElementById('navbar');
      this.gitlabHost = navbar.dataset.gitlabhost;
      const projects = JSON.parse(navbar.dataset.projects);
      // const milestonesMap = new Map();
      for (let project of projects) {
        if (!project.is_member) {
          continue;
        }
        let milestones = project.milestones;
        for (let milestone of milestones) {
          // milestonesMap.set(project.id, true);
          this.milestones.push(milestone);
        }
        this.projects.push({
          id: project.id,
          name: project.name,
          webUrl: project.web_url,
          access: project.access
        });
      }
    },
    updated() {
      if (this.dialogVisible) {
        const $dialog = document.getElementsByClassName('el-dialog')[0];
        const navHeight = document.getElementById('navbar').clientHeight;
        const total = document.documentElement.clientHeight;
        $dialog.style.maxHeight = (total - 100) + 'px';
        $dialog.style.overflowY = 'auto';
      }
    },
    methods: {
      handleSelect(key, keyPath) {
        if (key.startsWith('1-')) {
          let project_id = key.substr(2);
          window.location.href = `/projects/${project_id}/kanban`;
        }
        // 新建冲刺
        else if (key.startsWith('2-new')) {
          let list = key.split('-');
          let projectId = parseInt(list[list.length - 1]);
          let webUrl = this.projects.find((p) => p.id === projectId).webUrl;
          window.open(`${webUrl}/milestones/new`);
        } else if (key.startsWith('2-')) {
          let list = key.substr(2).split('-');
          if (list.length === 3) {
            let milestone_id = list[1];
            let route = list[2];
            window.location.href = `/milestones/${milestone_id}/${route}`;
          }
        } else if (key === '3') {
          window.location.href = '/issues';
        } else if (key === '4') {
          window.location.href = '/blogs'
        } else if (key === '5') {
          window.location.href = "/classrooms";
        } else if (key === '6') {
          window.location.href = this.gitlabHost;
        } else if (key.startsWith('7-')) {
          this.newIssue.projectId = parseInt(key.substr(2));
          this.dialogVisible = true;
        }
      },
      handleClose(done) {
        this.$confirm('确认关闭？')
          .then(_ => {
            done();
          })
          .catch(_ => {
          });
      },
      addIssue(formName) {
        this.$refs['newIssue'].$refs[formName].validate((valid) => {
          if (valid) {
            this.dialogVisible = false;
            this.newIssue.state = 'opened';
            window.eventhub.$emit('addNewIssue', this.newIssue);
            this.newIssue = new Issue();
          } else {
            return false;
          }
        })
      }
    }
  }
</script>
<style scoped>
  .navbar a {
    text-decoration: none;
  }

  .navbar i {
    font-size: 14px;
  }
</style>