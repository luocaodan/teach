import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
  const $login = document.getElementById('login');
  const login = new Vue({
    el: $login,
    data: {
      authUrl: '',
    },
    components: {

    },
    mounted() {
      const login = document.getElementById('login');
      this.authUrl = login.dataset.auth;
    },
    methods: {
      redirectToGitlab() {
        window.location.href = this.authUrl;
      }
    }
  });
});