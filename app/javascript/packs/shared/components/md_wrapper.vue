<template>
  <div class="md-wrapper">
    <mavon-editor
      ref="mdEditor"
      v-model="d_value"
      :subfield="false"
      :toolbars="toolbars"
      :toolbarsFlag="!preview"
      :editable="editable"
      :defaultOpen="defaultType"
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
        d_value: ''
      }
    },
    computed: {
      defaultType() {
        if (this.preview) {
          return 'preview';
        }
        return 'edit';
      },
    },
    watch: {
      d_value(val, oldVal) {
        this.$emit('input', val);
      },
      value(val, oldVal) {
        if (val !== this.d_value) {
          this.d_value = val;
        }
      }
    },
    props: {
      value: String,
      editable: Boolean,
      placeholder: String,
      project: Number,
      preview: Boolean,
      cantSave: Boolean
    },
    mounted() {
      this.toolbars.save = !this.cantSave;
      this.d_value = this.value;
    },
    methods: {
      getProjectId() {
        return this.project;
      }
    }
  }
</script>