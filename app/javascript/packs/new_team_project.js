import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import csrf from './shared/components/csrf.vue'

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#new-project-app',
    data() {
      return {
        project: {
          name: '',
          path: '',
          description: '',
          initialize_with_readme: false
        },
        rules: {
          name: [
            {required: true, message: '请输入团队项目名称', trigger: 'blur'}
          ],
          path: [
            {required: true, message: '请输入团队项目地址', trigger: 'blur'}
          ]
        }
      }
    },
    components: {
      csrf
    },
    mounted() {
      this.project = JSON.parse(this.$el.dataset.project)
      this.$watch('project.name', (newVal, oldVal) => {
        this.project.path = newVal.toLowerCase().trim().replace(/\s+/g, '-');
      })
    },
    methods: {
      submitForm() {
        this.$refs.project.validate((valid) => {
          if (valid) {
            this.$refs.project.$el.submit();
          } else {
            return false;
          }
        });
      }
    }
  })
})