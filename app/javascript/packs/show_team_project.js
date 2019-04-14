import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import ECharts from 'vue-echarts';
import 'echarts/lib/chart/pie';
import 'echarts/lib/component/tooltip';
import 'echarts/lib/component/title';
import 'echarts/lib/component/toolbox';
import 'echarts/lib/component/legendScroll';

Vue.use(ElementUI);
Vue.component('v-chart', ECharts);

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#show-team-app',
    data() {
      return {
        members: [],
        // 贡献选项 Commit | Issues | Weight
        // 默认 Commit
        option: 'Commit'
      }
    },
    computed: {
      contributionOption() {
        const member_names = this.members.map(i => i.name);
        let contribution_data;
        switch (this.option) {
          case 'Issues':
            contribution_data = this.members.map(i => {
              return {
                name: i.name,
                value: i.issues_count
              }
            });
            contribution_data.push({name: 'To Do', value: this.todo});
            break;
          case 'Weight':
            contribution_data = this.members.map(i => {
              return {
                name: i.name,
                value: i.issues_weight
              }
            });
            contribution_data.push({name: 'To Do', value: this.todoWeight});
            break;
          default:
            contribution_data = this.members.map(i => {
              return {
                name: i.name,
                value: i.commits_count
              }
            });
        }
        const option = {
          title: {
            text: '贡献统计',
            show: false
          },
          tooltip: {
            formatter: this.memberFmt,
          },
          toolbox: {
            feature: {
              saveAsImage: {
                title: '下载'
              },
            }
          },
          legend: {
            type: 'scroll',
            data: member_names,
            selectedMode: false,
          },
          series: [
            {
              type: 'pie',
              name: '贡献',
              data: contribution_data,
              label: {
                formatter: this.memberLabelFmt
              }
            }
          ]
        };
        return option;
      }
    },
    mounted() {
      this.members = JSON.parse(this.$el.dataset.members);
      this.todo = this.$el.dataset.todo;
      this.todoWeight = this.$el.dataset.todoWeight;
    },
    methods: {
      roleTagType(role) {
        const tagMap = {
          'Guest': 'info',
          'Reporter': 'warning',
          'Developer': 'success',
          'Maintainer': 'primary'
        };
        return tagMap[role];
      },
      memberFmt(params) {
        const membersIndex = params.dataIndex;
        if (membersIndex >= this.members.length) {
          return 'To Do';
        }
        const member = this.members[membersIndex];
        const template = `
          <div class="member" style="color: #fff">
            <div class="avatar">
              <img src="${member.avatar_url}"/>
            </div>
            <div>
              <div>${member.name}</div>
              <div>@${member.username}</div>
            </div>
            <div>
              <div>${this.option}</div>
              <div style="text-align: center;">${params.value}</div>
            </div>
          </div>
        `;
        return template;
      },
      memberLabelFmt(params) {
        const membersIndex = params.dataIndex;
        if (membersIndex >= this.members.length) {
          return 'To Do';
        }
        const member = this.members[membersIndex];
        return `${member.name}\n@${member.username}`
      }
    }
  })
});