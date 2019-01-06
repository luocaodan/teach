<template>
  <div class="left-bar list-board">
    <div v-if="this.label" ref="header" class="label-header" :style="{color: labelColor()}">
      {{ labelText() }}
    </div>
    <div ref="sort" class="sort center clearFloat">
      <span @click="reverse()">
        Order by {{ fieldMap(sort_field) }}
        <i class="iconfont" :class="{ 'icon-icarrowup': asc, 'icon-icarrowdown': !asc }"></i>
      </span>
      <el-dropdown @command="handleSortField">
          <span class="el-dropdown-link">
            <i class="el-icon-arrow-down el-icon--right"></i>
          </span>
        <el-dropdown-menu slot="dropdown">
          <el-dropdown-item command="created_at">创建日期</el-dropdown-item>
          <el-dropdown-item command="due_date">截止日期</el-dropdown-item>
          <el-dropdown-item command="weight">权重</el-dropdown-item>
          <el-dropdown-item command="priority">优先级</el-dropdown-item>
        </el-dropdown-menu>
      </el-dropdown>
      <span style="float: right" :title="'共' + issues.length + '个问题 总权重' + totalWeight">
        <svg class="icon" aria-hidden="true">
          <use xlink:href="#icon-Issue"></use>
        </svg>
        <span style="font-size: 16px">{{ issues.length }}</span>
        <svg class="icon" aria-hidden="true">
          <use xlink:href="#icon-weight"></use>
        </svg>
        <span style="font-size: 16px">{{ totalWeight }}</span>
      </span>
    </div>
    <div :style="{height: height + 'px'}">
      <el-scrollbar class="scroll center">
        <issue-card class="issue-item" :clicked="clicked === index && label === curLabel" v-for="(issue, index) in issues" :issue="issue"
                    :key="index" @click.native="clickIssue(index)"></issue-card>
      </el-scrollbar>
    </div>
  </div>
</template>

<script>
  import IssueCard from './issue_card.vue'
  import eventhub from '../eventhub'

  export default {
    components: {
      IssueCard
    },
    data: function () {
      return {
        sort_field: 'created_at',
        asc: false,
        sortHeight: 10,
        headerHeight: 0,
        heightFlag: false,
      }
    },
    props: {
      issues: Array,
      totalHeight: Number,
      clicked: Number,
      label: String,
      curLabel: String
    },
    computed: {
      height() {
        let diff = this.sortHeight + this.headerHeight;
        return this.totalHeight - diff - 2;
      },
      totalWeight() {
        let total = 0;
        for (let issue of this.issues) {
          if (issue.weight) {
            total += issue.weight;
          }
        }
        return total;
      }
    },
    mounted() {
      this.handleSortField(this.sort_field);
    },
    updated() {
      console.log(this.issues);
      if (!this.heightFlag) {
        const sort = this.$refs.sort;
        this.sortHeight = sort.offsetHeight;
        const header = this.$refs.header;
        if (header) {
          this.headerHeight = header.offsetHeight;
        }
        this.heightFlag = true;
      }
    },
    methods: {
      fieldMap() {
        const map = {
          weight: '权重',
          priority: '优先级',
          created_at: '创建日期',
          due_date: '截止日期'
        };
        return map[this.sort_field];
      },
      handleSortField(field) {
        if (field === this.sort_field) {
          return;
        }
        this.sort_field = field;
        eventhub.$emit('sort', this.sort_field, this.asc, this.label);
      },
      reverse() {
        this.asc = !this.asc;
        eventhub.$emit('reverse', this.label);
      },
      clickIssue(index) {
        eventhub.$emit('updateDetailIndex', index, this.label);
      },
      labelText() {
        const texts = {
          'todo': '待处理',
          'doing': '处理中',
          'done': '已完成'
        };
        return texts[this.label];
      },
      labelColor() {
        const colors = {
          'todo': '#F56C6C',
          'doing': '#E6A23C',
          'done': '#67C23A'
        };
        return colors[this.label];
      }
    }
  }
</script>
<style>
  .list-board .el-scrollbar__wrap {
    overflow-x: hidden;
  }
</style>
<style scoped>

  .issue-item {
    margin-bottom: 10px;
  }

  .scroll {
    height: 100%;
  }

  .center {
    margin: 0 10px;
  }

  .left-bar {
    /*position: absolute;*/
    /*margin-bottom: 0;*/
    /*padding: 0 10px;*/
  }

  .list-board {
    border: 1px solid #e5e5e5;
    background-color: #fafafa;
  }

  .sort {
    padding: 10px 0;
    font-size: 16px;
    color: #707070;
  }

  .sort > span {
    padding: 5px;
  }

  .sort > span:hover {
    background-color: #e6e6e6;
    -webkit-border-radius: 3px;
    -moz-border-radius: 3px;
    border-radius: 3px;
    cursor: pointer;
  }

  .label-header {
    text-align: center;
    border-bottom: 1px solid #e6e6e6;
    padding: 7px 0;
  }
</style>