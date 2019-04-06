import 'echarts/lib/component/markLine'

export default {
  data() {
    return {
      yAxisOption: '任务数',
      burnOption: null,
    }
  },
  computed: {
    isWeight() {
      if (this.yAxisOption === '任务数') {
        return false;
      } else {
        return true;
      }
    }
  },
  methods: {
    updateEchartsOption() {
      // 默认为任务数燃尽图
      const burnData = this.getBurnData(this.issues, this.isWeight);
      const guideData = this.getGuideData(burnData);
      const day = 3600 * 24;
      const start = Date.parse(this.milestone.start_date + ' GMT +8') / 1000;
      const end = Date.parse(this.milestone.due_date + ' GMT +8') / 1000 + day;
      const tmp = Math.max(end, this.roundDate(burnData[burnData.length-1][0])) - start;
      const xAxisInterval = Math.ceil(tmp / day / 10) * day;

      const last = burnData[burnData.length - 1][1];
      let markline = {};
      if (last > 0) {
        markline = {
          silent: true,
          symbol: 'none',
          label: {
            formatter: '今天'
          },
          data: [
            {
              name: '今天',
              xAxis: burnData[burnData.length - 1][0]
            }
          ]
        }
      }
      const that = this;
      this.burnOption = {
        title: {
          text: '燃尽图',
          show: false
        },
        tooltip: {
          formatter: function (params) {
            const data = params.data;
            const day = 24 * 3600;
            // 判断整天
            let time = null;
            let date = new Date(data[0] * 1000).toLocaleDateString();
            if (data[0] % day === 57600) {
              time = date;
            }
            else {
              time = `${date} ${new Date(data[0] * 1000).toLocaleTimeString()}`;
            }
            return `${time} 剩余 ${Math.round(data[1] * 10) / 10}`
          }
        },
        toolbox: {
          // 图片另存为
          feature: {
            dataZoom: {},
            saveAsImage: {
              title: '下载'
            },
            dataView: {}
          },
        },
        legend: {
          data: ['实际', '计划']
        },
        xAxis: {
          type: 'value',
          min: start,
          max: Math.max(end, this.roundDate(burnData[burnData.length - 1][0])),
          interval: xAxisInterval,
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
            markLine: markline
          },
          {
            name: '计划',
            data: guideData,
            type: 'line'
          }],
        animation: false
      };
    },
    getBurnData(data, isWeight) {
      // X 坐标转换函数
      const toX = (timestamp) => {
        return Math.round(timestamp / 1000);
      };
      const start = this.milestone.start_date;
      // 判断是否为开始日之前
      const isBeforeFirstDay = (timestamp) => {
        const startTime = Date.parse(start + 'GMT +8') + 3600 * 24 * 1000;
        return timestamp < startTime;
      };
      // weight 默认 0
      const defWeight = weight => weight ? weight : 0;
      // 总任务数
      let total = 0;
      // 总工时 开始日之前创建的任务
      let totalWeight = 0;
      for (let issue of data) {
        const createTime = Date.parse(issue.created_at);
        if (isBeforeFirstDay(createTime)) {
          total += 1;
          totalWeight += defWeight(issue.weight);
        }
      }

      const res = [];
      // 起始值
      const startX = toX(Date.parse(start + 'GMT +8'));
      if (isWeight) {
        res.push([startX, totalWeight]);
      } else {
        res.push([startX, total]);
      }

      const events = [];
      for (let issue of data) {
        const create = toX(Date.parse(issue.created_at));
        events.push({
          time: create,
          type: 'create',
          weight: defWeight(issue.weight)
        });
        if (issue.closed_at) {
          const close = toX(Date.parse(issue.closed_at));
          events.push({
            time: close,
            type: 'close',
            weight: defWeight(issue.weight)
          });
        }
      }

      // 事件按事件排序
      events.sort((a, b) => {
        return a.time - b.time;
      });

      // 时间 任务数映射
      const timeMap = {};
      for (let event of events) {
        // 每个时间赋值为默认值
        timeMap[event.time] = {
          count: total,
          weight: totalWeight,
          isModify: false
        }
      }

      // 积累的完成任务数
      let cumulateCount = 0;
      let cumulateWeight = 0;
      for (let event of events) {
        const create = event.time;

        if (event.type === 'create' && !isBeforeFirstDay(create * 1000)) {
          cumulateCount -= 1;
          cumulateWeight -= event.weight;

          timeMap[create]['count'] -= cumulateCount;
          timeMap[create]['weight'] -= cumulateWeight;
          timeMap[create]['isModify'] = true;
        }

        if (event.type === 'close') {
          const close = event.time;
          cumulateCount += 1;
          cumulateWeight += event.weight;
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
      res.sort((a, b) => {
        return a[0] - b[0];
      });
      // 加入实时数据
      const last = res[res.length - 1][1];
      if (last > 0) {
        res.push([Math.round(new Date().getTime() / 1000), last]);
      }
      return res;
    },
    getGuideData(burnData) {
      const DAY = 24 * 3600;
      const start = Date.parse(this.milestone.start_date + 'GMT +8') / 1000;
      const end = Date.parse(this.milestone.due_date + 'GMT +8') / 1000 + DAY;

      const total = burnData.length > 0 ? burnData[0][1] : 0;
      const diff = total / ((end - start) / 3600 / 24);
      let w = total;
      const res = [];
      for (let i = start; i <= end; i += 3600 * 24) {
        if (w <= 0) {
          res.push([i, 0]);
        } else {
          res.push([i, Math.round(w*10) / 10]);
          w -= diff;
        }
      }
      return res;
    },
    dateStr(str, isUtc = false) {
      // str 为UTC时间
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
    },
    changeYAxis() {
      this.updateEchartsOption();
    },
    roundDate(second) {
      const d = new Date(second * 1000);
      d.setHours(0, 0, 0, 0);
      const day = 3600 * 24;
      return d.getTime()/1000 + day;
    },
  }
}