import {mavonEditor} from 'mavon-editor'
import UploadService from '../../services/upload_service'
import axios from 'axios/index'
import AlertMixin from "./alert";

export default {
  data() {
    return {
      toolbars: {
        bold: true, // 粗体
        italic: true, // 斜体
        header: true, // 标题
        underline: false, // 下划线
        strikethrough: false, // 中划线
        mark: true, // 标记
        superscript: false, // 上角标
        subscript: false, // 下角标
        quote: true, // 引用
        ol: true, // 有序列表
        ul: true, // 无序列表
        link: true, // 链接
        imagelink: true, // 图片链接
        code: true, // code
        table: true, // 表格
        fullscreen: true, // 全屏编辑
        readmodel: false, // 沉浸式阅读
        htmlcode: false, // 展示html源码
        help: false, // 帮助
        undo: true, // 上一步
        redo: true, // 下一步
        trash: false, // 清空
        save: true, // 保存（触发events中的save事件）
        navigation: false, // 导航目录
        alignleft: false, // 左对齐
        aligncenter: false, // 居中
        alignright: false, // 右对齐
        subfield: false, // 单双栏模式
        preview: true, // 预览
      },
      maxHeight: 280,
      enabled: false,
      markdownIt: null,
    }
  },
  mixins: [AlertMixin],
  mounted() {
    this.enableGFM();
  },
  methods: {
    resizeMarkdown(status, value) {
      // const $editor = document.getElementById('markdown-editor');
      let maxHeight = 280;
      if (status) {
        maxHeight = document.documentElement.clientHeight;
        // 全功能Markdown编辑器
        this.fullFunction(true);
      } else {
        this.fullFunction(false);
      }
      this.maxHeight = maxHeight;
    },
    fullFunction(full) {
      const disables = [
        'underline', 'strikethrough',
        'superscript', 'subscript',
        'readmodel', 'htmlcode',
        'trash', 'subfield',
        'navigation'
      ];
      for (let field of disables) {
        this.toolbars[field] = full;
      }
    },
    getMarkdownIt() {
      if (!this.markdownIt) {
        this.markdownIt = mavonEditor.getMarkdownIt();
      }
      return this.markdownIt;
    },
    enableGFM() {
      if (this.enabled) {
        return;
      }
      let md = this.getMarkdownIt();
      md.set({linkify: true});

      let defaultImgRender = md.renderer.rules.image;
      md.renderer.rules.image = (tokens, idx, options, env, self) => {
        let srcIndex = tokens[idx].attrIndex('src');
        if (srcIndex >= 0) {
          let link = tokens[idx].attrs[srcIndex][1];
          if (link.startsWith('/uploads/')) {
            tokens[idx].attrs[srcIndex][1] = this.getProjectUrl() + link;
          }
        }
        return defaultImgRender(tokens, idx, options, env, self);
      };
      this.enabled = true;
    },
    $imgAdd(pos, $file) {
      let formData = new FormData();
      formData.append('image', $file);
      this.loading = true;
      UploadService.upload(this.getProjectId(), formData)
        .then(res => res.data)
        .then((data) => {
          const mdEditor = this.$refs.mdEditor;
          mdEditor.$img2Url(pos, data.url);
          this.loading = false;
        })
        .catch((e) => {
          this.$refs.mdEditor.$refs.toolbar_left.$imgDel(pos);
          this.alert('上传失败');
          this.loading = false;
        });
    },
    $imgDel(filename) {
      // todo
    },
    getProjectId() {
      this.alert('project id 未实现')
    },
    getProjectUrl() {
      this.alert('project url 未实现')
    }
  }
}