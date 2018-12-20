<template>
  <div class="sidebar">
    <div v-on:mousedown="drag" class="divider" :style="{height: totalHeight + 'px'}">
    </div>
    <detail-issue :issue="detailIssue" :index="detailIndex"></detail-issue>
  </div>
</template>
<script>
  import DetailIssue from './detail_issue.vue'
  import eventhub from '../../issues/eventhub'
  import Issue from '../../issues/models/issue'

  export default {
    components: {
      DetailIssue
    },
    data() {
      return {
        dragable: false,
        preX: 0,
      }
    },
    props: {
      detailIssue: Issue,
      totalHeight: Number,
      detailIndex: Number
    },
    methods: {
      drag(src) {
        this.preX = src.clientX;
        this.dragable = true;
        document.onmousemove = (des) => {
          this.updateWidth(des);
        };
        document.onmouseup = (des) => {
          this.updateWidth(des);
          this.dragable = false;
        }
      },
      updateWidth(des) {
        if (!this.dragable) {
          return;
        }
        let diff = des.clientX - this.preX;
        this.preX = des.clientX;
        eventhub.$emit('updateAsideWidth', diff);
      }
    }
  }
</script>
<style scoped>
  .divider {
    float: left;
    width: 15px;
    cursor: col-resize;
    background-color: #fff;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
  }
</style>