import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import CommonMixin from './shared/components/mixins/common_mixin'
import eventhub from './issues/eventhub'
import BlogsService from "./blogs/services/blogs_service";

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
      blogsHeight() {
        const $filter = document.getElementById('blog-filter');
        return this.height - $filter.offsetHeight - 2 - 10;
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
        return new Date(Date.parse(utcStr))
          .toLocaleDateString()
          .replace(/\//g, '-');
      }
    }
  })
});
