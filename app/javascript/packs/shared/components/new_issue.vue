<template>
  <div class="new-issue">
    <el-form ref="newIssueForm" :model="issue" :rules="rules" label-width="80px">
      <el-form-item label="Project" prop="projectId">
        <el-select v-model="issue.projectId" placeholder="选择项目">
          <el-option v-for="(project, index) in projects" :key="index" :label="project.name" :value="project.id"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="Title" prop="title">
        <el-input v-model="issue.title"></el-input>
      </el-form-item>
      <el-form-item label="Description" prop="description">
        <el-input v-model="issue.description" type="textarea" :autosize="{ minRows: 4 }"></el-input>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
  import Issue from '../../issues/models/issue'

  export default {
    data() {
      return {
        // detail form
        detail: false,
        projects: [],
        rules: {
          projectId: [
            {required: true, message: '请选择项目', trigger: 'change'}
          ],
          title: [
            {required: true, message: '请输入问题', trigger: 'blur'}
          ],
          description: [

          ]
        }
      }
    },
    props: {
      issue: Issue
    },
    mounted() {
      const $navbar = document.getElementById('navbar');
      this.projects = JSON.parse($navbar.dataset.projects);
    }
  }
</script>
<style scoped>
  .new-issue {

  }
</style>