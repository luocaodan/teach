<template>
  <div class="left-bar list-board">
    <div id="sort" class="sort center">
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
    </div>
    <div :style="{height: height + 'px'}">
      <el-scrollbar class="scroll center">
        <issue-card class="issue-item" v-for="issue in issues" :issue="issue" :key="issue.id"></issue-card>
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
        height: 400,
        sort_field: 'created_at',
        asc: false,
      }
    },
    props: {
      issues: Array
    },
    mounted() {
      window.onresize = () => {
        let navHeight = document.getElementById('navbar').clientHeight;
        let sortHeight = document.getElementById('sort').clientHeight;
        let filterHeight = document.getElementById('filter').clientHeight;
        // 2px border
        let heightDiff = navHeight + sortHeight + filterHeight + 2;
        this.height = document.documentElement.clientHeight - heightDiff;
      };
      window.onresize();
      this.handleSortField(this.sort_field);
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
      }
    }
  }
</script>
<style>
  .el-scrollbar__wrap {
    overflow-x: hidden;
  }
  
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
    padding: 0 20px;
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