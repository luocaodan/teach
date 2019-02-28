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
      :boxShadow="boxShadow"
      @fullScreen="resizeMarkdown"
      @imgAdd="$imgAdd"
      @imgDel="$imgDel"
      @save="save"
      :placeholder="placeholder"
      :style="styleObj"
      :class="{ 'no-border': !border && preview }"
    >
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
      styleObj() {
        if (this.preview) {
          return {
            height: 'auto',
            minHeight: 'unset'
          }
        }
        else if (this.minHeight) {
          return {
            minHeight: `${this.minHeight}px`
          }
        }
        else {
          return {};
        }
      }
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
      editable: {
        type: Boolean,
        default: true
      },
      placeholder: String,
      project: Number,
      preview: {
        type: Boolean,
        default: false
      },
      cantSave: Boolean,
      boxShadow: {
        type: Boolean,
        default: true
      },
      minHeight: {
        type: Number,
        default: 0
      },
      border: {
        type: Boolean,
        default: true
      },
      func: {
        // full | middle | mini
        type: String,
        default: 'middle'
      }
    },
    mounted() {
      this.toolbars.save = !this.cantSave;
      if (this.func === 'mini') {
        this.fullFunction(false);
        const disables = ['undo', 'redo', 'header', 'mark'];
        for (let attr of disables) {
          this.toolbars[attr] = false;
        }
      }
      this.d_value = this.value;
    },
    methods: {
      save() {
        this.$emit('save');
      },
      getProjectId() {
        return this.project;
      }
    }
  }
</script>
<style>
  .no-border > .v-note-panel {
    border: none !important;
  }
  
  .no-border .v-show-content {
    background: #fff !important;
    padding: 0 !important;
  }
</style>