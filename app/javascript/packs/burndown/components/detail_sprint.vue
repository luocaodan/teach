<template>
  <div class="detail-sprint" v-if="sprint">
    <div class="sprint-title">
      <el-row>
        <el-col :span="16">
          <el-input
            id="sprint-title"
            class="big-label"
            v-if="policy.title"
            v-model="sprint.title"
            @blur="update('title')"></el-input>
          <label class="big-label" v-else @click="openPolicy('title')">{{ sprint.title }}</label>
        </el-col>
        <el-col :span="8" class="clearFloat">
          <el-button style="width: auto;float: right" v-if="sprint.state === 'closed'" @click="update('activate')">
            Reopen
          </el-button>
          <el-button style="width: auto;float: right" v-else type="danger" @click="update('close')">Close</el-button>
        </el-col>
      </el-row>
    </div>
    <div class="sprint-description">
      <div class="block-title">
        <span>冲刺描述</span>
        <i class="el-icon-edit title-icon" @click="openPolicy('description')"></i>
      </div>
      <div class="block-value">
        <mavon-editor
          v-if="policy.description"
          id="issue-description"
          ref="mdEditor"
          :style="{maxHeight: maxHeight + 'px', margin: '0px'}"
          v-model="sprint.description"
          :subfield="false"
          :toolbars="toolbars"
          @fullScreen="resizeMarkdown"
          @imgAdd="$imgAdd"
          @imgDel="$imgDel"
          @save="update('description')"
          placeholder="输入冲刺描述">
        </mavon-editor>
        <div v-else>
          <div class="sprint-html-container markdown-body" v-if="sprint.description" v-html="renderedDescription">
          </div>
          <div v-else>
            无冲刺描述
          </div>
        </div>
      </div>
    </div>
    <div class="sprint-date">
      <div class="block-title">
        <span>日期</span>
        <i class="el-icon-date title-icon"></i>
      </div>
      <el-row class="block-value">
        <el-col :span="12">
          <span>
            开始日期：
          </span>
          <el-date-picker
            size="mini"
            v-model="sprint.start_date"
            align="right"
            type="date"
            value-format="yyyy-MM-dd"
            placeholder="选择日期"
            @change="update('start_date')"
            :picker-options="pickerOptions">
          </el-date-picker>
        </el-col>
        <el-col :span="12">
          <span>
            截止日期：
          </span>
          <el-date-picker
            size="mini"
            v-model="sprint.due_date"
            align="right"
            type="date"
            value-format="yyyy-MM-dd"
            placeholder="选择日期"
            @change="update('due_date')"
            :picker-options="pickerOptions">
          </el-date-picker>
        </el-col>
      </el-row>
    </div>
    <div class="block-title">
      <span>燃尽图</span>
      <i class="iconfont icon-burndowncharticon title-icon"></i>
    </div>
  </div>
</template>

<script>
  import MarkdownMixin from '../../shared/components/mixins/markdown_support';
  import DateMixin from '../../shared/components/mixins/date_support'
  import eventhub from '../../issues/eventhub'
  import 'github-markdown-css'
  import Sprint from '../../burndown/models/sprint'

  export default {
    updated() {
      if (this.sprint.isCome && !this.copied) {
        this.rawSprint = Object.assign({}, this.sprint);
        this.copied = true;
      }
    },
    mixins: [MarkdownMixin, DateMixin],
    data() {
      return {
        policy: {
          title: false,
          description: false,
        }
      }
    },
    computed: {
      renderedDescription() {
        let md = this.getMarkdownIt();
        return md.render(this.sprint.description);
      }
    },
    props: {
      sprint: Sprint
    },
    methods: {
      openPolicy(attr) {
        this.policy[attr] = true;
        if (attr === 'title') {
          setTimeout(() => {
            document.getElementById('sprint-' + attr).focus();
          }, 0);
        }
      },
      update(attr) {
        if (!['activate', 'close'].includes(attr) && this.sprint[attr] === this.rawSprint[attr]) {
          this.policy[attr] = false;
          return;
        }
        let value = this.sprint[attr];
        if (['activate', 'close'].includes(attr)) {
          value = attr;
          attr = 'state_event';
        }
        const update = {};
        update[attr] = value;
        eventhub.$emit('updateSprint', update);
        this.policy[attr] = false;
      },
      getProjectId() {
        return this.sprint.projectId;
      }
    }
  }
</script>

<style scoped>
  .detail-sprint > * {
    margin: 20px 0;
  }

  .big-label {
    font-size: 26px;
    font-weight: 600;
  }

  .block-title {
    font-size: 16px;
    border-bottom: 1px solid #e6e6e6;
    padding-bottom: 10px;
  }

  .title-icon {
    padding: 5px;
  }

  .block-value {
    margin: 1em 0;
  }
</style>
<style>
  .sprint-html-container {
    padding: 15px;
  }

  .sprint-html-container img {
    max-width: 100%;
  }
</style>