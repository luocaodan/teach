<template>
  <div class="md-wrapper" v-loading="loading" element-loading-text="上传中">
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
        d_value: '',
        loading: false
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
        const base = {
          minWidth: '250px'
        };
        if (this.preview) {
          return Object.assign(base, {
            height: 'auto',
            minHeight: 'unset'
          })
        }
        else if (this.minHeight) {
          return Object.assign(base, {
            minHeight: `${this.minHeight}px`
          })
        }
        else {
          return Object.assign(base, {});
        }
      }
    },
    watch: {
      d_value(val, oldVal) {
        this.$emit('input', val);
      },
      value(val, oldVal) {
        if (val !== this.d_value) {
          this.d_value = val.toString();
        }
      }
    },
    props: {
      value: [String, Number],
      editable: {
        type: Boolean,
        default: true
      },
      placeholder: String,
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
      },
      projectId: Number,
      projectUrl: String
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
        return this.projectId;
      },
      getProjectUrl() {
        if (this.projectUrl) {
          return this.projectUrl;
        }
        const $navbar = document.getElementById('navbar');
        const projects = JSON.parse($navbar.dataset.projects);
        const projectUrl = projects.find((p) => p.id === this.getProjectId()).web_url;
        return projectUrl;
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