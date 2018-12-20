<template>
  <div class="detail-issue" v-if="issue">
    <div>
      <text-editable label="" v-model="issue.title" :can-edit="true"></text-editable>
    </div>

  </div>
</template>

<script>
  import Issue from '../../issues/models/issue'
  import TextEditable from './text_editable.vue'

  export default {
    data() {
      return {}
    },
    components: {
      TextEditable
    },
    props: {
      issue: Issue,
      index: Number
    },
    methods: {
    }
  }
</script>
<style scoped>
  .detail-issue {
    padding: 20px;
  }

  .detail-issue h1 {
    font-size: 24px;
    font-weight: normal;
    margin: 0;
  }
</style>