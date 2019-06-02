<template>
  <div class="new-issue">
    <el-form ref="newIssueForm" :model="issue" :rules="rules" label-width="80px">
      <el-form-item label="项目" prop="projectId">
        <el-select v-model="issue.projectId" placeholder="选择项目">
          <el-option v-for="(project, index) in projects"
                     :key="index" :label="project.name_with_namespace"
                     :value="project.id"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="问题标题" prop="title">
        <el-input v-model="issue.title"></el-input>
      </el-form-item>
      <el-form-item label="问题描述" prop="description">
        <md-wrapper v-model="issue.description"
                    :border="false" :box-shadow="false"
                    :project-id="issue.projectId"
                    func="mini"
                    :cant-save="true">
        </md-wrapper>
      </el-form-item>

      <div>
        <el-row>
          <el-col :span="11">
            <el-form-item label="权重" prop="weight">
              <el-input v-model.number="issue.weight"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="11" :offset="1">
            <el-form-item label="优先级" prop="priority">
              <el-select v-model="issue.priority" class="full-width">
                <el-option label="高" :value="3"></el-option>
                <el-option label="中" :value="2"></el-option>
                <el-option label="低" :value="1"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="11">
            <el-form-item label="冲刺" prop="milestone">
              <el-select
                v-model="issue.milestone.id"
                class="full-width"
                placeholder="选择冲刺">
                <el-option label="无冲刺" :value="0"></el-option>
                <el-option v-for="(milestone, index) in milestoneList(issue)"
                           :key="index" :label="milestone.title"
                           :value="milestone.id"></el-option>

              </el-select>
            </el-form-item>
          </el-col>

          <el-col :span="11" :offset="1">
            <el-form-item label="截止日期" prop="dueDate">
              <el-date-picker
                v-model="issue.dueDate"
                align="right"
                type="date"
                value-format="yyyy-MM-dd"
                placeholder="选择日期"
                class="full-width"
                :picker-options="pickerOptions">
              </el-date-picker>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="11">
            <el-form-item label="经办人" prop="assignee">
              <el-select
                class="full-width"
                v-model="issue.assignee.id"
                :loading="membersLoading"
                @focus="pullMembers"
                placeholder="选择经办人">
                <el-option label="无经办人" :value="0"></el-option>
                <el-option
                  v-for="(member, index) in members"
                  :key="index"
                  :label="member.name"
                  :value="member.id">
                  <span>
                    <img style="height: 13px;width:13px;display:inline" :src="member.avatar">
                    {{ member.name }}
                  </span>
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>

          <el-col :span="11" :offset="1">
            <el-form-item label="标签" prop="labels">
              <el-select
                v-model="issue.labels"
                class="full-width"
                :loading="labelsLoading"
                @focus="pullLabels"
                multiple placeholder="选择标签">
                <el-option v-for="(label, index) in labels"
                           :key="index" :label="label.name"
                           :value="label.name"></el-option>
              </el-select>
            </el-form-item>
          </el-col>

        </el-row>
      </div>

    </el-form>
  </div>
</template>

<script>
  import Issue from '../../issues/models/issue'
  import DateMixin from './mixins/date_support'
  import AlertMixin from './mixins/alert'
  import mdWrapper from './md_wrapper.vue'
  import IssuesService from "../../issues/services/issues_service";

  export default {
    mixins: [DateMixin, AlertMixin],
    components: {
      mdWrapper
    },
    data() {
      let validateWeight = (rule, value, callback) => {
        if (value === null || value === '') {
          callback();
        }
        if (!Number.isInteger(value)) {
          callback(new Error('权重必须为整数'));
          return;
        }
        let weight = parseInt(value);
        if (weight < 1) {
          callback(new Error('权重至少为1'));
        } else if (weight > 20) {
          callback(new Error('权重最大为20'));
        } else {
          callback();
        }
      };
      return {
        projects: [],
        labels: {},
        labelsLoading: false,
        members: {},
        membersLoading: false,
        milestones: {},
        rules: {
          projectId: [
            {required: true, message: '请选择项目', trigger: 'change'}
          ],
          title: [
            {required: true, message: '请输入问题', trigger: 'blur'}
          ],
          weight: [
            {validator: validateWeight, trigger: 'blur'}
          ],
          priority: [],
        },
      }
    },
    props: {
      issue: Issue,
    },
    mounted() {
      const $navbar = document.getElementById('navbar');
      const projects = JSON.parse($navbar.dataset.projects);

      for (let project of projects) {
        this.milestones[project.id] = project.milestones;
        this.projects.push({
          id: project.id,
          name: project.name,
          name_with_namespace: project.name_with_namespace,
        });
      }
      const navbar = document.getElementById('navbar');
      this.issuesService = new IssuesService({
        issuesEndpoint: navbar.dataset.issuesEndpoint
      });
    },
    methods: {
      pullLabels() {
        this.labelsLoading = true;
        this.issuesService.getProjectLabels(this.issue.projectId)
          .then(res => res.data)
          .then(data => {
            this.labels = data;
            this.labelsLoading = false;
          })
          .catch(e => {
            this.alert('拉取标签失败')
          })
      },
      pullMembers() {
        this.membersLoading = true;
        this.issuesService.getProjectMembers(this.issue.projectId)
          .then(res => res.data)
          .then(data => {
            this.members = data;
            this.membersLoading = false;
          })
          .catch(e => {
            this.alert('拉取团队成员失败')
          })
      },
      milestoneList(issue) {
        return this.milestones[issue.projectId];
      },
    }
  }
</script>
<style>
  .new-issue .el-date-editor.el-input {
    width: 100%;
  }
</style>
<style scoped>
  .new-issue {
    min-width: 400px;
  }

  .full-width {
    width: 100%;
  }
</style>