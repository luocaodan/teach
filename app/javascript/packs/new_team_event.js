import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import csrf from '../src/shared/components/csrf.vue'
import MonacoEditor from 'vue-monaco'

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#new-team-event-app',
    data() {
      return {
        event: {},
        rules: {
          name: [
            {required: true, message: '请输入团队事件名称', trigger: 'blur'}
          ],
          description: [
            {required: true, message: '请填写团队事件描述来更好的区分事件', trigger: 'blur'}
          ],
          code: [
            {required: true, message: '请输入事件定义代码', trigger: 'blur'}
          ]
        },
        vscodeOptions: {
          automaticLayout: true
        },
        illustrateUrl: 'https://gist.github.com/luocaodan/cf175e433db58e0b150337ddad4c393a'
      }
    },
    components: {
      csrf,
      MonacoEditor
    },
    mounted() {
      this.event = JSON.parse(this.$el.dataset.event)
    },
    methods: {
      submitForm() {
        this.$refs.event.validate((valid) => {
          if (valid) {
            this.$refs.event.$el.submit();
          } else {
            return false;
          }
        });
      },
    }
  })
});