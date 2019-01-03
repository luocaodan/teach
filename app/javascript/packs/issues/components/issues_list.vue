<template>
  <div class="left-bar list-board">
    <div id="sort" class="sort center clearFloat">
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
      <span style="float: right">
        <svg class="icon" aria-hidden="true">
          <use xlink:href="#icon-weight"></use>
        </svg>
        <span style="font-size: 16px">{{ totalWeight }}</span>
      </span>
    </div>
    <div :style="{height: height + 'px'}">
      <el-scrollbar class="scroll center">
        <issue-card class="issue-item" :clicked="clicked === index" v-for="(issue, index) in issues" :issue="issue"
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
      }
    },
    props: {
      issues: Array,
      totalHeight: Number,
      clicked: Number,
    },
    computed: {
      height() {
        let heightDiff = this.sortHeight + 2;
        return this.totalHeight - heightDiff;
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
      const sort = document.getElementById('sort');
      this.sortHeight = sort.clientHeight;
    },
    updated() {
      console.log(this.issues);
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
        eventhub.$emit('sort', this.sort_field, this.asc);
      },
      reverse() {
        this.asc = !this.asc;
        eventhub.$emit('reverse');
      },
      clickIssue(index) {
        this.$emit('update:clicked', index);
      },
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
</style>