<template>
  <div>
    <el-card shadow="hover" :body-style="{ padding: '0px' }">
      <div style="padding: 14px">
        <div class="main-info">
          <span>{{ issue.title }}</span>
          <i :title="issue.state" class="iconfont" :class="{ 'icon-wancheng': closed, 'icon-daibanshixiang': !closed }"></i>

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
          <el-tag size="mini" :type="labelType(label)">{{ label }}</el-tag>
        </span>
        <div class="issue-info">
          <i class="iconfont icon-xiangmu"></i>
          <span title="项目">{{ issue.project_name }}</span>
          <span v-if="issue.due_date">
            <i class="el-icon-date"></i>
            <span title="截止日期">{{ issue.due_date }}</span>
          </span>
          <span class="assignee" v-if="issue.assignee">
            <img :title="'经办人: ' + issue.assignee.username" :src="issue.assignee.avatar_url">
          </span>

        </div>
      </div>
    </el-card>
  </div>
</template>
<script>
  export default {
    components: {},
    props: {
      issue: Object
    },
    computed: {
      closed() {
        return this.issue.state === 'closed'
      },
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
          'icon-low_priority',
          'icon-medium_priority',
          'icon-high_priority'
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
</style>