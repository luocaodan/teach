import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import CommonMixin from '../src/shared/components/mixins/common_mixin'
import BlogsService from "../src/blogs/services/blogs_service";
import Moment from "../src/tools/moment";

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
  const blogsApp = new Vue({
    el: '#blogs-app',
    components: {},
    mixins: [CommonMixin],
    data() {
      return {
        projects: [],
        blogs: [],
        loading: false,
        searchParams: {
          type: 'all',
          scope: 'all',
        }
      }
    },
    computed: {
      loadingStyle() {
        if (this.loading) {
          return {
            minHeight: '400px'
          }
        }
      }
    },
    watch: {
      searchParams: {
        handler: function(val, oldVal) {
          this.updateBlogs(this.searchParams);
        },
        deep: true
      }
    },
    mounted() {
      const $app = this.getContainer();
      this.blogsService = new BlogsService({
        blogsEndpoint: $app.dataset.blogsEndpoint
      });

      this.updateBlogs(this.searchParams);
    },
    methods: {
      updateBlogs(params) {
        this.loading = true;
        this.blogsService
          .all(params)
          .then(res => res.data)
          .then(data => {
            this.blogs = data;
            this.loading = false;
          })
      },
      blogTagType(blogType) {
        if (blogType === 'Blog') {
          return 'success';
        }
        return 'primary'
      },
      dateStr(utcStr) {
        return Moment.dateStr(utcStr);
      }
    }
  })
});
