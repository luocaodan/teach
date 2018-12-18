<template>
  <div class="sidebar">
    <detail-issue :issue="detailIssue"></detail-issue>
  </div>
</template>
<script>
  import DetailIssue from './detail_issue.vue'

  export default {
    components: {
      DetailIssue
    },
    props: {
      detailIssue: Object
    }
  }
</script>