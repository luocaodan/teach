import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import csrf from './shared/components/csrf.vue'

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#new-classroom-app',
    data() {
      return {
        classroom: {
          name: '',
          path: '',
          description: ''
        },
        rules: {
          name: [
            {required: true, message: '请输入班级名称', trigger: 'blur'}
          ],
          path: [
            {required: true, message: '请输入班级地址', trigger: 'blur'}
          ]
        }
      }
    },
    components: {
      csrf
    },
    mounted() {
      this.classroom = JSON.parse(this.$el.dataset.classroom)
      this.$watch('classroom.name', (newVal, oldVal) => {
        this.classroom.path = newVal.toLowerCase().trim().replace(/\s+/g, '-');
      })
    },
    methods: {
      submitForm() {
        this.$refs.classroom.validate((valid) => {
          if (valid) {
            this.$refs.classroom.$el.submit();
          } else {
            return false;
          }
        });
      }
    }
  })
});