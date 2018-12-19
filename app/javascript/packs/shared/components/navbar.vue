<template>
  <div class="navbar">
    <el-menu
      :default-active="kanban"
      class="el-menu-demo"
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
      <el-menu-item index="2">
        <a href="/issues">
          问题
        </a>
      </el-menu-item>

      <el-menu-item index="3">
        <a :href="gitlabHost" target="_blank">
          GitLab
          <i class="iconfont icon-link"></i>
          <!--<svg aria-hidden="true" class="icon">-->
            <!--<use xlink:href="#icon-link"></use>-->
          <!--</svg>-->
        </a>
      </el-menu-item>

      <el-menu-item index="4" style="float: right">
        新建问题
      </el-menu-item>
    </el-menu>

    <el-dialog
      title="New Issue"
      :visible.sync="dialogVisible"
      width="70%"
      :before-close="handleClose">
      <detail-issue :issue="newIssue"></detail-issue>
      <span slot="footer" class="dialog-footer">
    <el-button @click="dialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="dialogVisible = false">确 定</el-button>
  </span>
    </el-dialog>
  </div>
</template>
<script>
  import DetailIssue from './detail_issue.vue'

  export default {
    components: {
      DetailIssue
    },
    data() {
      return {
        kanban: '1',
        issues: '2',
        gitlab: '3',
        projects: [],
        gitlabHost: '',
        dialogVisible: false,
        newIssue: {}
      };
    },
    mounted() {
      const navbar = document.getElementById('navbar');
      this.projects = JSON.parse(navbar.dataset.projects);
      this.gitlabHost = navbar.dataset.gitlabhost;
    },
    methods: {
      handleSelect(key, keyPath) {
        if (key.startsWith('1-')) {
          let project_id = key.substr(2);
          window.location.href = '/boards/' + project_id;
        } else if (key === '4') {
          this.dialogVisible = true;
        }
      },
      handleClose(done) {
        this.$confirm('确认关闭？')
          .then(_ => {
            done();
          })
          .catch(_ => {});
      }
    }
  }
</script>
<style>
  .navbar a {
    text-decoration: none;
  }

  .navbar i {
    font-size: 14px;
  }
</style>