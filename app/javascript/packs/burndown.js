import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import ECharts from 'vue-echarts';
import 'echarts/lib/chart/line';
import 'echarts/lib/component/tooltip';
import 'echarts/lib/component/title';
import 'echarts/lib/component/toolbox';
import 'echarts/lib/component/legend';
import IssuesService from "./issues/services/issues_service";
import AlertMixin from './shared/components/mixins/alert';

Vue.use(ElementUI);
Vue.component('v-chart', ECharts);

document.addEventListener('DOMContentLoaded', () => {
  const burndownApp = new Vue({
    el: '#burndown-app',
    components: {},
    mixins: [AlertMixin],
    data() {
      return {
        milestone: null,
        loading: false,
        burnOption: null
      }
    },
    mounted() {
      const $app = document.getElementById('burndown-app');
      const issuesEndpoint = $app.dataset.endpoint;
      this.issuesService = new IssuesService({
        issuesEndpoint: issuesEndpoint
      });

      this.updateBurnInfo();
    },
    methods: {
      updateBurnInfo() {
        const params = this.getParams();
        if (!this.milestone.start_date || !this.milestone.due_date) {
          this.alert('请为冲刺添加开始日期和截止日期');
          return;
        }
        this.loading = true;
        this.issuesService
          .all(params)
          .then(res => res.data)
          .then(data => {
            // 默认为任务数燃尽图
            const burnData = this.getBurnData(data, true);
            const guideData = this.getGuideData(burnData);
            const start = Date.parse(this.dateStr(this.milestone.start_date)) / 1000;
            const end = Date.parse(this.dateStr(this.milestone.due_date)) / 1000;
            const that = this;
            this.burnOption = {
              title: {
                text: '燃尽图',
                show: true
              },
              tooltip: {
                trigger: 'axis',
                axisPointer: {
                  type: 'cross',
                  label: {
                    backgroundColor: '#6a7985',
                    formatter: function (params) {
                      const time = params.value;
                      if (time < start) {
                        return Math.round(time * 10) / 10;
                      } else {
                        return that.dateFmt(time * 1000, true);
                      }
                    }
                  }
                }
              },
              toolbox: {
                // 图片另存为
                feature: {
                  saveAsImage: {},
                  dataView: {},
                },
                showTitle: false
              },
              legend: {
                data: ['实际', '计划']
              },
              xAxis: {
                type: 'value',
                data() {
                  const res = [];
                  for (let i = start; i <= end; i += 3600 * 24) {
                    res.push(i);
                  }
                  return res;
                },
                min: start,
                max: end,
                interval: 3600 * 24,
                axisLabel: {
                  formatter: function (value, index) {
                    return that.dateFmt(value * 1000);
                  }
                }
              },
              yAxis: {
                type: 'value',
                min: 0
              },
              series: [
                {
                  name: '实际',
                  data: burnData,
                  type: 'line',
                  smooth: true
                },
                {
                  name: '计划',
                  data: guideData,
                  type: 'line'
                }]
            };
            this.loading = false;
          })
      },
      getParams() {
        const pathname = window.location.pathname;
        let list = pathname.split('/');
        let milestoneId = parseInt(list[2]);
        const $navbar = document.getElementById('navbar');
        const projects = JSON.parse($navbar.dataset.projects);
        let milestone = null;
        let projectId = null;
        for (let project of projects) {
          milestone = project.milestones.find(
            (m) => m.id === milestoneId
          );
          if (milestone) {
            projectId = project.id;
            break;
          }
        }
        this.milestone = milestone;
        return {
          milestone: milestone.title,
          project: projectId
        }
      },
      getBurnData(data, isWeight) {
        const start = this.milestone.start_date;
        // 总任务数
        let total = 0;
        // 总工时
        let totalWeight = 0;
        for (let issue of data) {
          let create = this.dateStr(issue.created_at);
          if (create === this.dateStr(start)) {
            total += 1;
            totalWeight += issue.weight;
          }
        }

        const res = [];
        // 起始值
        const startX = Date.parse(start + 'GMT +8') / 1000;
        if (isWeight) {
          res.push([startX, totalWeight]);
        } else {
          res.push([startX, total]);
        }

        data.sort((a, b) => {
          const stampA = Date.parse(a);
          const stampB = Date.parse(b);
          if (stampA <= stampB) {
            return -1;
          } else {
            return 1;
          }
        });


        // 时间 任务数映射
        const timeMap = {};
        const def = {
          count: total,
          weight: totalWeight,
          isModify: false
        };
        // 每个时间赋值为默认值
        for (let issue of data) {
          const create = Date.parse(issue.created_at) / 1000;
          timeMap[create] = Object.assign({}, def);
          if (issue.closed_at) {
            const close = Date.parse(issue.closed_at) / 1000;
            timeMap[close] = def;
          }
        }

        // 积累的完成任务数
        let cumulateCount = 0;
        let cumulateWeight = 0;
        const startDate = new Date(startX * 1000).toLocaleDateString();
        for (let issue of data) {
          const create = Date.parse(issue.created_at) / 1000;

          // 非首日
          if (this.dateStr(issue.created_at) !== startDate) {
            cumulateCount -= 1;
            cumulateWeight -= issue.weight;

            timeMap[create]['count'] -= cumulateCount;
            timeMap[create]['weight'] -= cumulateWeight;
            timeMap[create]['isModify'] = true;
          }

          if (issue.closed_at) {
            const close = Date.parse(issue.closed_at) / 1000;
            cumulateCount += 1;
            cumulateWeight += issue.weight;
            timeMap[close]['count'] -= cumulateCount;
            timeMap[close]['weight'] -= cumulateWeight;
            timeMap[close]['isModify'] = true;
          }
        }
        for (let time in timeMap) {
          const info = timeMap[time];
          if (!info.isModify) {
            continue;
          }
          const val = isWeight ? info.weight : info.count;
          res.push([time, val]);
        }
        return res;
      },
      getGuideData(burnData) {
        const start = Date.parse(this.milestone.start_date + 'GMT +8') / 1000;
        const end = Date.parse(this.milestone.due_date + 'GMT +8') / 1000;

        const total = burnData.length > 0 ? burnData[0][1] : 0;
        const diff = total / ((end - start) / 3600 / 24);
        let w = total;
        const res = [];
        for (let i = start; i <= end; i += 3600 * 24) {
          if (total === 0) {
            res.push([i, 0]);
          } else {
            res.push([i, w]);
            w -= diff;
          }
        }
        return res;
      },
      getMockData() {
        const d = 3600 * 24;
        const start = Date.parse(this.milestone.start_date + 'GMT +8') / 1000;
        const end = Date.parse(this.milestone.due_date + 'GMT +8') / 1000;
        return [[start, 100], [start + d, 94], [start + 1.5 * d, 85]];
      },
      dateStr(str, isUtc = false) {
        if (isUtc) {
          return new Date(Date.parse(str)).toDateString();
        }
        return new Date(Date.parse(str)).toLocaleDateString();
      },
      dateFmt(timestamp, isFull = false) {
        const d = new Date(timestamp);
        let res = `${d.getMonth() + 1}/${d.getDate()}`;
        if (isFull) {
          const h = d.getHours(), m = d.getMinutes(), s = d.getSeconds();
          if (h + m + s > 0) {
            res += ` ${d.getHours()}:${d.getMinutes()}:${d.getSeconds()}`;
          }
        }
        return res;
      }
    }
  })
});
