<template>
  <div class="new-issue">
    <el-form ref="newIssueForm" :model="issue" :rules="rules" label-width="80px">
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
          id="markdown-editor"
          ref="mdEditor"
          style="max-height: 280px;"
          v-model="issue.description"
          :subfield="false"
          :toolbars="toolbars"
          @fullScreen="resizeMarkdown"
          @helpToggle="navigateToHelp"
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

  export default {
    mixins: [EditMixin],
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
        toolbars: {
          bold: true, // 粗体
          italic: true, // 斜体
          header: true, // 标题
          underline: false, // 下划线
          strikethrough: false, // 中划线
          mark: true, // 标记
          superscript: false, // 上角标
          subscript: false, // 下角标
          quote: true, // 引用
          ol: true, // 有序列表
          ul: true, // 无序列表
          link: true, // 链接
          imagelink: true, // 图片链接
          code: true, // code
          table: true, // 表格
          fullscreen: true, // 全屏编辑
          readmodel: false, // 沉浸式阅读
          htmlcode: false, // 展示html源码
          help: false, // 帮助
          undo: true, // 上一步
          redo: true, // 下一步
          trash: false, // 清空
          save: false, // 保存（触发events中的save事件）
          navigation: false, // 导航目录
          alignleft: false, // 左对齐
          aligncenter: false, // 居中
          alignright: false, // 右对齐
          subfield: false, // 单双栏模式
          preview: true, // 预览
        }
      }
    },
    mounted() {
      this.enableGFM();
    },
    methods: {
      resizeMarkdown(status, value) {
        const $editor = document.getElementById('markdown-editor');
        let maxHeight = 280;
        if (status) {
          maxHeight = document.documentElement.clientHeight;
          // 全功能Markdown编辑器
          this.fullFunction(true);
        } else {
          this.fullFunction(false);
        }
        $editor.style.maxHeight = maxHeight + 'px';
      },
      fullFunction(full) {
        const disables = [
          'underline', 'strikethrough',
          'superscript', 'subscript',
          'readmodel', 'htmlcode',
          'help', 'trash', 'subfield',
          'navigation'
        ];
        for (let field of disables) {
          this.toolbars[field] = full;
        }
      },
      navigateToHelp(status, value) {
        if (status) {
          const $navbar = document.getElementById('navbar');
          const gitlabHost = $navbar.dataset.gitlabhost;
          let helpUrl = gitlabHost + '/help/user/markdown';
          window.open(helpUrl);
        }
      },
      enableGFM() {
        let md = this.$refs.mdEditor.markdownIt;
        md.set({linkify: true});
      }
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