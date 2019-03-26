import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
  const $login = document.getElementById('login');
  const login = new Vue({
    el: $login,
    data() {
      return {
        authUrl: '',
      }
    },
    components: {

    },
    mounted() {
    },
    methods: {
      redirectToGitlab(authUrl) {
        window.location.href = authUrl;
      }
    }
  });
});