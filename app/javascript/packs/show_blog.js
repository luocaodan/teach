import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import MavonEditor from 'mavon-editor'
import 'mavon-editor/dist/css/index.css'
import mdWrapper from '../src/shared/components/md_wrapper.vue'
import BlogsService from "../src/blogs/services/blogs_service";
import CommentsService from "../src/comments/services/comments_service";
import Endpoint from "../src/tools/endpoint";
import Moment from "../src/tools/moment";
import AlertMixin from "../src/shared/components/mixins/alert";

Vue.use(ElementUI);
Vue.use(MavonEditor);

document.addEventListener('DOMContentLoaded', () => {
  const showBlogApp = new Vue({
    mixins: [AlertMixin],
    el: '#show-blog-app',
    components: {
      mdWrapper
    },
    mounted() {
      const $app = this.getContainer();
      const blog = JSON.parse($app.dataset.blog);
      const pathname = window.location.pathname;
      blog.code = '';
      this.blog = blog;
      this.blogsService = new BlogsService({
        blogsEndpoint: $app.dataset.blogsEndpoint
      });
      this.commentsService = new CommentsService({
        commentsEndpoint: $app.dataset.commentsEndpoint
      });
      this.getBlogCode();
      this.getComments();
    },
    updated() {
      if (this.blog.isCome) {
        this.rawBlog = Object.assign({}, this.blog);
        this.blog.isCome = false;
      }
    },
    data() {
      return {
        loading: false,
        codeLoading: false,
        commentsLoading: false,
        deleteLoading: false,
        blog: null,
        comments: [],
        policy: {
          title: false,
          code: false,
        },
        currentEditComment: null,
        n_comment: {
          body: ''
        }
      }
    },
    methods: {
      getBlogCode() {
        this.codeLoading = true;
        this.blogsService
          .getBlogCode(this.blog.id)
          .then(res => res.data)
          .then(data => {
            this.blog.code = data;
            this.blog.isCome = true;
            this.codeLoading = false;
            this.gotoComments();
          })
          .catch(() => {
            this.alert('获取博客内容失败');
          });
      },
      gotoComments() {
        const hash = window.location.hash;
        if (hash) {
          this.$nextTick(() => {
            const anchorId = hash.substr(1);
            setTimeout(() => {
              document.getElementById(anchorId).scrollIntoView()
            }, 0)
          });
        }
      },
      getComments() {
        this.commentsLoading = true;
        this.commentsService
          .getComments()
          .then(res => res.data)
          .then(data => {
            this.comments = data;
            this.commentsLoading = false;
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
        if (this.blog[attr] === this.rawBlog[attr]) {
          this.closePolicy(attr);
          return;
        }
        const update = {};
        update[attr] = this.blog[attr];
        this.loading = true;
        this.blogsService
          .updateBlog(this.blog.id, update)
          .then(res => res.data)
          .then(data => {
            const code = this.blog.code;
            data.project_id = this.blog.project_id;
            this.blog = data;
            this.loading = false;
            this.closePolicy(attr);
            this.blog.code = code;
            this.blog.isCome = true;
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
          this.deleteLoading = true;
          this.blogsService.deleteBlog(this.blog.id)
            .then(res => res.data)
            .then(data => {
              if (data === 'success') {
                this.success('删除成功');
                const $app = this.getContainer();
                window.location.href = Endpoint.getPrefix($app.dataset.blogsEndpoint);
              }
              else {
                this.alert('删除失败');
              }
              this.deleteLoading = false;
            })
            .catch(e => {
              this.alert('删除失败');
              this.deleteLoading = false;
            })
        }).catch(() => {

        });
      },
      isPreview(commentId) {
        return this.currentEditComment !== commentId;
      },
      editComment(commentId) {
        this.currentEditComment = parseInt(commentId);
        this.currentEditCommentBody = this.comments.find((c) =>
          c.id === commentId
        ).body;
      },
      newComment() {
        this.loading = true;
        this.commentsService
          .newComment(this.n_comment)
          .then(res => res.data)
          .then(data => {
            this.comments.splice(this.comments.length, 0, data);
            this.n_comment = {
              body: ''
            };
            this.loading = false;
          })
      },
      updateComment() {
        const comment = this.comments.find(c => c.id === this.currentEditComment);
        const body = comment.body;
        if (body === this.currentEditCommentBody) {
          this.currentEditComment = null;
          this.currentEditCommentBody = null;
          return;
        }
        const update = {
          body
        };
        this.loading = true;
        this.commentsService
          .updateComment(this.currentEditComment, update)
          .then(res => res.data)
          .then(data => {
            this.currentEditComment = null;
            this.currentEditCommentBody = null;
            comment.updated_at = data.updated_at;
            this.loading = false;
          })
          .catch(() => {
            this.loading = false;
            this.alert('更新失败');
          });
      },
      deleteComment(commentId) {
        this.$confirm('确认删除？', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.loading = true;
          this.commentsService.deleteComment(commentId)
            .then(res => res.data)
            .then(data => {
              this.loading = false;
              if (data === 'success') {
                this.success('删除成功');
                const index = this.comments.findIndex(c => c.id === commentId);
                this.comments.splice(index, 1);
              }
              else {
                this.alert('删除失败');
              }
            })
        });
      },
      dateStr(utcStr) {
        return Moment.dateStr(utcStr);
      },
      timeStr(utcStr) {
        return Moment.timeStr(utcStr);
      }
    }
  });
});