<template>
  <div class="clearFloat issue-card">
    <el-card shadow="hover" :class="{clicked: clicked}"
             :body-style="{ padding: '0px' }">
      <div style="padding: 14px">
        <div class="main-info">
          <span>{{ issue.title | shorten }}</span>
          <el-tag style="margin: 4px" :type="stateType(issue.state)" size="mini">{{ issue.state }}</el-tag>

          <span v-if="issue.priority">
            <svg class="icon" aria-hidden="true">
              <use v-bind:xlink:href="priorityClass(issue.priority)" :title="priorityText(issue.priority)"></use>
            </svg>
          </span>

          <span v-if="issue.weight" class="right">
            <svg class="icon" aria-hidden="true">
              <use xlink:href="#icon-weight"></use>
            </svg>
            <span style="font-size: 16px">{{ issue.weight }}</span>
          </span>
        </div>
        <span v-for="label in issue.labels">
          <el-tag class="label-item" size="mini" :type="labelType(label)">{{ label }}</el-tag>
        </span>
        <div class="issue-info">
          <i class="iconfont icon-xiangmu"></i>
          <span title="项目">{{ issue.projectName }}</span>
          <span v-if="issue.dueDate">
            <i class="el-icon-date"></i>
            <span title="截止日期">{{ issue.dueDate }}</span>
          </span>
          <span class="assignee" v-if="issue.assignee.id">
            <img :title="'经办人: ' + issue.assignee.username" :src="issue.assignee.avatar">
          </span>

        </div>
      </div>
    </el-card>
  </div>
</template>
<script>
  import Issue from '../models/issue'

  export default {
    components: {},
    props: {
      issue: Issue,
      clicked: false,
      label: String
    },
    computed: {
      closed() {
        return this.issue.state === 'closed'
      },
    },
    filters: {
      shorten(value) {
        let len = 0;
        let end;
        const MAX = 18;
        for (end = 0;end < value.length;end++) {
          if (len > MAX) {
            break;
          }
          const unicode = value.charCodeAt(end);
          if (unicode > 255) {
            len += 2;
          }
          else {
            len += 1;
          }
        }
        if (len > MAX) {
          value = value.substr(0, end) + '...'
        }
        return value;
      }
    },
    methods: {
      labelType(label) {
        if (['bug', 'confirmed', 'critical'].includes(label)) {
          return 'danger';
        }
        else if (label === 'enhancement') {
          return 'success';
        }
        else {
          return '';
        }
      },
      priorityClass(priority) {
        let classes = [
          'icon-low_priority1',
          'icon-medium_priority1',
          'icon-high_priority1'
        ];
        return '#' + classes[priority-1];
      },
      priorityText(priority) {
        let texts = [
          'Low',
          'Medium',
          'High'
        ];
        return texts[priority];
      },
      stateType(state) {
        if (state === 'Closed') {
          return 'success';
        } else if (state === 'Doing') {
          return 'warning';
        }
        return 'danger';
      }
    }
  }
</script>
<style scoped>
  .main-info svg {
    width: 16px;
    height: 16px;
  }

  .issue-info {
    color: #999;
    margin-top: 13px;
    font-size: 13px;
  }

  .issue-info i {
    font-size: 13px;
  }

  .assignee {
    float: right;
  }
  .assignee img {
    width: 13px;
    height: 13px;
  }

  .right {
    float: right;
  }

  .clicked {
    background-color: #ebf2f9;
  }

  .label-item {
    margin: 3px;
  }
</style>