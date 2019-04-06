<template>
  <div class="navbar clearFloat">
    <el-menu
      mode="horizontal"
      @select="handleSelect"
      background-color="#545c64"
      text-color="#fff"
      active-text-color="#ffd04b">
      <el-menu-item index="1">
        班级
      </el-menu-item>
      <el-menu-item index="2">
        GitLab
        <i class="iconfont icon-link"></i>
      </el-menu-item>
    </el-menu>
  </div>
</template>
<script>
  export default {
    data() {
      return {
        gitlabHost: ''
      }
    },
    mounted() {
      this.gitlabHost = document.getElementById('navbar').dataset.gitlabhost;
    },
    methods: {
      handleSelect(key) {
        if (key === '1') {
          window.location.href = '/classrooms';
        }
        else if (key === '2') {
          window.location.href = this.gitlabHost;
        }
      }
    }
  }
</script>