<template>
  <input v-if="rawIssue" @change="haha">
</template>

<script>
  import Issue from '../../issues/models/issue'

  export default {
    data() {
      return {
      }
    },
    props: {
      rawIssue: Object,
    },
    computed: {
      issue() {
        return Issue.valueOf(this.rawIssue);
      }
    },
    methods: {
      haha() {
        console.log(this.issue);
        console.log(Issue.valueOf(this.issue));
      }
    }
  }
</script>