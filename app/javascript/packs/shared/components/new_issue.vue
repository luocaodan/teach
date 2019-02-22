<template>
  <div class="new-issue">
    <el-form ref="newIssueForm" :model="issvue" :rules="rules" label-width="80px">
      <el-form-item label="项目" prop="projectId">
        <el-select v-model="issue.projectId" placeholder="选择项目">
          <el-option v-for="(project, index) in projects" :key="index" :label="project.name"
                     :value="project.id"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="问题标题" prop="title">
        <el-input v-model="issue.title"></el-input>
      </el-form-item>
      <el-form-item label="问题描述" prop="description">
        <!--<el-input v-model="issue.description" type="textarea" :autosize="{ minRows: 4 }"></el-input>-->
        <mavon-editor
          ref="mdEditor"
          :style="{maxHeight: maxHeight + 'px'}"
          v-model="issue.description"
          :subfield="false"
          :toolbars="toolbars"
          @fullScreen="resizeMarkdown"
          @imgAdd="$imgAdd"
          @imgDel="$imgDel"
          placeholder="输入问题描述">
        </mavon-editor>
      </el-form-item>

      <div v-if="canEdit">
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
            <el-form-item label="经办人" prop="assignee">
              <el-select
                class="full-width"
                v-model="issue.assignee.id"
                placeholder="选择经办人">
                <el-option label="无经办人" :value="0"></el-option>
                <el-option
                  v-for="(member, index) in memberList(issue)"
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
            <el-form-item label="标签" prop="labels">
              <el-select
                v-model="issue.labels"
                class="full-width"
                multiple placeholder="选择标签">
                <el-option v-for="(label, index) in labelList(issue)"
                           :key="index" :label="label.name"
                           :value="label.name"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="11" :offset="1">
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
        </el-row>
      </div>

    </el-form>
  </div>
</template>

<script>
  import EditMixin from './mixins/edit_issue'
  import MarkdownMixin from './mixins/markdown_support'

  export default {
    mixins: [EditMixin, MarkdownMixin],
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
    mounted() {
      this.editorMounted = true;
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