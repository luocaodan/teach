import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import MavonEditor from 'mavon-editor'
import 'mavon-editor/dist/css/index.css'
import CommonMixin from './shared/components/mixins/common_mixin'
import mdWrapper from './shared/components/md_wrapper.vue'
import BlogsService from "./blogs/services/blogs_service";
import Blog from "./blogs/models/blog";

Vue.use(ElementUI);
Vue.use(MavonEditor);

document.addEventListener('DOMContentLoaded', () => {
  const showBlogApp = new Vue({
    el: '#show-blog-app',
    mixins: [CommonMixin],
    components: {
      mdWrapper
    },
    mounted() {
      const $app = this.getContainer();
      const blog = JSON.parse($app.dataset.blog);
      const pathname = window.location.pathname;
      let list = pathname.split('/');
      blog.code = '';
      blog.project_id = parseInt(list[2]);
      this.blog = blog;
      this.blogsService = new BlogsService({
        blogsEndpoint: $app.dataset.blogsEndpoint
      });
      this.getBlogCode();
    },
    updated() {
      if (this.blog.isCome) {
        this.rawBlog = this.blog;
      }
    },
    data() {
      return {
        loading: false,
        codeLoading: false,
        blog: null,
        policy: {
          title: false,
          code: false,
        }
      }
    },
    methods: {
      getBlogCode() {
        this.codeLoading = true;
        this.blogsService
          .getBlogCode(this.blog.project_id, this.blog.id)
          .then(res => res.data)
          .then(data => {
            this.blog.code = data;
            this.blog.isCome = true;
            this.codeLoading = false;
          })
      },
      openPolicy(attr) {
        this.policy[attr] = true;
        if (attr === 'title') {
          setTimeout(() => {
            document.getElementById('blog-' + attr).focus();
          }, 0);
        }
      },
      closePolicy(attr) {
        this.policy[attr] = false;
      },
      update(attr) {
        const update = {};
        update[attr] = this.blog[attr];
        this.loading = true;
        this.blogsService
          .updateBlog(this.blog.project_id, this.blog.id, update)
          .then(res => res.data)
          .then(data => {
            const code = this.blog.code;
            data.project_id = this.blog.project_id;
            this.blog = data;
            this.loading = false;
            this.closePolicy(attr);
            this.blog.code = code;
          })
          .catch(e => {
            this.alert('更新失败');
          });
      },
      deleteBlog() {
        this.$confirm('确认删除？', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.blogsService.deleteBlog(this.blog.project_id, this.blog.id)
            .then(res => res.data)
            .then(data => {
              if (data === 'success') {
                this.success('删除成功');
                setTimeout(() => {
                  window.location.href = '/blogs';
                }, 1000);
              }
              else {
                this.alert('删除失败');
              }
            })
        }).catch(() => {

        });
      },
      dateStr(utcStr) {
        return new Date(Date.parse(utcStr))
          .toLocaleDateString()
          .replace(/\//g, '-');
      }
    }
  });
});