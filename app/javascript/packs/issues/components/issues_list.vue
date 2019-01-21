<template>
  <div class="left-bar list-board">
    <div v-if="this.label" ref="header" class="label-header" :style="{color: labelColor()}">
      {{ labelText() }}
      <svg class="icon" aria-hidden="true">
        <use :xlink:href="labelIcon()"></use>
      </svg>
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
      <div v-if="isBox" class="drag-box" :style="dragBoxStyle()">

      </div>
      <el-scrollbar class="scroll center" v-else>
        <issue-card class="issue-item" :class="{ 'draggable-issue': canDrag}" :label="label"
                    :clicked="clicked === index && label === curLabel"
                    v-for="(issue, index) in issues" :issue="issue"
                    :key="index" @click.native="clickIssue(index)"
                    @mousemove.native="checkMove"
                    @mousedown.native.stop="startDrag(index, $event)">
        </issue-card>
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
      curLabel: String,
      isBox: Boolean,
      canDrag: Boolean
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
      },
      labelIcon() {
        const icons = {
          'todo': '#icon-daibanshixiang',
          'doing': '#icon-mux-task-doing',
          'done': '#icon-wancheng'
        };
        return icons[this.label];
      },
      dragBoxStyle() {
        const borderColor = this.labelColor();
        const height = this.height > 400 ? 400 : this.height * 0.9;
        return {
          height: `${height}px`,
          border: `3px dashed ${borderColor}`
        }
      },
      startDrag(index, e) {
        if (!this.canDrag) {
          return;
        }
        this.isDrag = true;
        this.cardIndex = index;
        e = e || event;
        this.card = e.currentTarget;
        this.isMoveFirst = true;
        document.addEventListener('mousemove', this.dragMove);
        document.addEventListener('mouseup', this.endDrag);
        this.leftDis = document.getElementById('boards-app').scrollLeft;
      },
      dragMove(e) {
        if (!this.isDrag) {
          return;
        }
        if (!this.isMove) {
          return;
        }

        if (this.isMoveFirst) {
          this.isMoveFirst = false;
          this.dx = e.layerX;
          this.dy = e.layerY;
          let sx = e.clientX - this.dx;
          let sy = e.clientY - this.dy;
          const width = document.querySelector('.draggable-issue').offsetWidth;
          const stylus = {
            position: 'fixed',
            width: width + 'px',
            zIndex: 10,
            left: sx + 'px',
            top: sy + 'px'
          };
          // 创建临时元素
          this.tempNode = this.card.cloneNode(true);
          Object.assign(this.tempNode.style, stylus);
          document.body.appendChild(this.tempNode);
          // 显示吸附框
          eventhub.$emit('displayBox', this.label);
        }

        e = e || event;
        let mx = e.clientX - this.dx;
        let my = e.clientY - this.dy;
        this.tempNode.style.left = mx + 'px';
        this.tempNode.style.top = my + 'px';
        document.removeEventListener('mousemove', this.dragMove);
        setTimeout(() => {
          document.addEventListener('mousemove', this.dragMove);
        }, 30);
      },
      endDrag(e) {
        if (!this.isDrag) {
          return;
        }
        this.isDrag = false;
        if (!this.isMove) {
          this.clickIssue(this.cardIndex);
          return;
        }
        this.isMove = false;
        e = e || event;
        const x = e.clientX + this.leftDis;
        this.leftDis = null;
        const d = document.querySelector('.el-aside').offsetWidth;
        console.log(x, d);
        let label = null;
        if (x > 0.2 * d && x < d * 0.8) {
          label = 'todo';
        } else if (x > 1.2 * d && x < 1.8 * d) {
          label = 'doing';
        } else if (x > 2.2 * d && x < 2.8 * d) {
          label = 'done';
        } else {
          // do nothing
        }

        eventhub.$emit('displayBox', null);
        // clear up for gc
        document.body.removeChild(this.tempNode);
        this.tempNode = null;
        this.dx = null;
        this.dy = null;

        if (label && label !== this.label) {
          eventhub.$emit('updateIssueState', this.label, this.cardIndex, label);
        }
        this.cardIndex = null;
        document.removeEventListener('mousemove', this.dragMove);
        document.removeEventListener('mouseup', this.endDrag);
      },
      checkMove() {
        if (this.isDrag) {
          this.isMove = true;
        }
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
    border-bottom: 1px solid #dcdfe6;
    padding: 7px 0;
  }

  .drag-box {
    background-color: #ebf2f9;
    margin: 10px;
  }

  .draggable-issue {
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
  }

  .draggable-issue:hover {
    cursor: move;
  }

  body .draggable-issue {
    -webkit-transition: 0ms;
    -moz-transition: 0ms;
    -o-transition: 0ms;
    transition: 0ms;
  }
</style>