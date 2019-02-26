<template>
  <div class="md-wrapper">
    <mavon-editor
      ref="mdEditor"
      v-model="myContent"
      :subfield="false"
      :toolbars="toolbars"
      :editable="editable"
      @fullScreen="resizeMarkdown"
      @imgAdd="$imgAdd"
      @imgDel="$imgDel"
      :placeholder="placeholder">
    </mavon-editor>
  </div>
</template>
<script>
  import MarkdownMixin from './mixins/markdown_support'

  export default {
    mixins: [MarkdownMixin],
    data() {
      return {
        myContent: ''
      }
    },
    watch: {
      myContent(value) {
        this.$emit('update:content', value);
      }
    },
    props: {
      content: String,
      editable: Boolean,
      placeholder: String,
      project: Number
    },
    mounted() {
      this.toolbars.save = false;
      this.myContent = this.content;
    },
    methods: {
      getProjectId() {
        return this.project;
      }
    }
  }
</script>