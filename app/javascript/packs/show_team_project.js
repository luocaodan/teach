import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#show-team-app',
    data() {
      return {
        members: []
      }
    },
    mounted() {
      this.members = JSON.parse(this.$el.dataset.members);
    },
    methods: {
      roleTagType(role) {
        const tagMap = {
          'Guest': 'info',
          'Reporter': 'warning',
          'Developer': 'success',
          'Maintainer': 'primary'
        }
        return tagMap[role];
      }
    }
  })
})