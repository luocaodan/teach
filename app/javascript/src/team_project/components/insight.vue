<template>
  <div class="insight">
    <div class="insight-filter clearFloat">
      <el-radio-group v-model="contributionType"
                      size="mini" @change="update">
        <el-radio-button label="Commit"></el-radio-button>
        <el-radio-button label="Issues"></el-radio-button>
        <el-radio-button label="Weight"></el-radio-button>
      </el-radio-group>
      <el-dropdown @command="selectMember">
        <span class="el-dropdown-link">
          {{ currentMN }}<i class="el-icon-arrow-down el-icon--right"></i>
        </span>
        <el-dropdown-menu slot="dropdown">
          <el-dropdown-item command="all">所有团队成员</el-dropdown-item>
          <el-dropdown-item
            v-for="(member, index) in members"
            :key="index" :command="index">
            <div class="member">
              <div class="avatar">
                <img :src="member.avatar_url"/>
              </div>
              <div class="member-text">
                <div>{{ member.name }}</div>
                <div>@{{ member.username }}</div>
              </div>
            </div>
          </el-dropdown-item>
        </el-dropdown-menu>
      </el-dropdown>
      <el-date-picker
        v-model="dateRange"
        size="mini"
        type="daterange"
        align="right"
        range-separator="-"
        start-placeholder="开始日期"
        end-placeholder="结束日期"
        class="floatRight"
        @change="update"
        :picker-options="dateOptions">
      </el-date-picker>
    </div>
    <div class="insight-result">
      <v-chart :options="contributionOption"
               ref="contributionChart"
               @click="zoomChart">
      </v-chart>
    </div>
  </div>
</template>
<script>
  import axios from 'axios/index'
  import moment from 'moment/moment'

  export default {
    data() {
      return {
        contributionData: null,
        members: [],
        contributionType: 'Commit',
        currentMemberIndex: 'all',
        dateRange: '',
        dateOptions: {
          shortcuts: [{
            text: '最近一周',
            onClick(picker) {
              const end = new Date();
              const start = new Date();
              start.setTime(start.getTime() - 3600 * 1000 * 24 * 7);
              picker.$emit('pick', [start, end]);
            }
          }, {
            text: '最近一个月',
            onClick(picker) {
              const end = new Date();
              const start = new Date();
              start.setTime(start.getTime() - 3600 * 1000 * 24 * 30);
              picker.$emit('pick', [start, end]);
            }
          }, {
            text: '最近三个月',
            onClick(picker) {
              const end = new Date();
              const start = new Date();
              start.setTime(start.getTime() - 3600 * 1000 * 24 * 90);
              picker.$emit('pick', [start, end]);
            }
          }],
          disabledDate(time) {
            return time.getTime() > new Date().getTime();
          }
        }
      }
    },
    computed: {
      currentMN() {
        if (this.currentMemberIndex === 'all') {
          return '所有团队成员'
        }
        const member = this.members[this.currentMemberIndex];
        return `${member.name} @${member.username}`;
      },
      contributionIcon() {
        let name;
        if (this.contributionType === 'Commit') {
          name = 'Commit'
        } else if (this.contributionType === 'Issues') {
          name = 'Issue'
        } else {
          name = 'weight';
        }
        return `<i class="iconfont icon-${name}"></i>`
      },
      contributionOption() {
        if (!this.contributionData) {
          return {}
        }
        const option = {
          title: {
            text: '贡献详细统计',
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
          dataZoom: {
            type: 'inside'
          },
          xAxis: {
            name: '日期',
            data: this.contributionData.map(i => i[0]),
            axisTick: {
              alignWithLabel: true
            },
            nameTextStyle: {
              fontStyle: 'italic',
            }
          },
          yAxis: {
            name: this.contributionType,
            nameTextStyle: {
              fontStyle: 'italic',
            }
          },
          series: [
            {
              type: 'bar',
              data: this.contributionData.map(i => i[1]),
            }
          ]
        };
        return option;
      }
    },
    mounted() {
      this.members = JSON.parse(this.$el.dataset.members);
      // 时间范围 默认为最近一周
      const end = new Date();
      const start = new Date();
      start.setTime(start.getTime() - 3600 * 1000 * 24 * 7);
      this.dateRange = [start, end];
      this.update();
    },
    methods: {
      selectMember(index) {
        this.currentMemberIndex = index;
        this.update();
      },
      update() {
        // 更新贡献数据
        this.$refs.contributionChart.showLoading();
        const endpoint = this.$el.dataset.endpoint;
        let member;
        if (this.currentMemberIndex !== 'all') {
          member = this.members[this.currentMemberIndex].id;
        }
        axios.get(endpoint, {
          params: {
            type: this.contributionType,
            member: member,
            from: this.dateRange[0],
            to: this.dateRange[1]
          }
        })
          .then(res => res.data)
          .then(data => {
            this.contributionData = this.fillDays(data);
            this.$refs.contributionChart.hideLoading();
          })
          .catch(e => {
            this.$message.error('数据加载错误')
          })
      },
      memberFmt(params) {
        const template = `
          <div>
            <i class="el-icon-date"></i>
            <span>${params.name}</span>
          </div>
          <div class="clearFloat">
            ${this.contributionIcon}
            <span>${this.contributionType}</span>
            <span class="floatRight">${params.value}</span>
          </div>
        `;
        return template;
      },
      fillDays(data) {
        const addOneDay = (dateStr) => {
          const res = moment(dateStr, 'YYYY-MM-DD');
          res.add(1, 'd');
          return res.format('YYYY-MM-DD');
        };
        const isDateEqual = (strA, strB) => {
          const a = moment(strA, 'YYYY-MM-DD').toDate();
          const b = moment(strB, 'YYYY-MM-DD').toDate();
          console.log(a, b)
          return a.getTime() === b.getTime();
        };
        // 填充贡献为 0 的日期
        const res = [];
        for (let item of data) {
          if (!res.length) {
            res.push(item);
            continue;
          }
          const top = res[res.length - 1];
          let current = addOneDay(top[0]);
          while (!isDateEqual(current, item[0])) {
            res.push([current, 0]);
            current = addOneDay(current);
          }
          res.push(item);
        }
        return res;
      },
      zoomChart(params) {
        // 点击自动缩放
        const zoomSize = 7;
        const dataIndex = params.dataIndex;
        this.$refs.contributionChart.dispatchAction({
          type: 'dataZoom',
          startValue: Math.max(0, dataIndex - zoomSize/2),
          endValue: Math.min(this.contributionData.length - 1, dataIndex + zoomSize/2)
        });
      }
    }
  }
</script>
<style scoped>
  .insight-filter {
    border-bottom: 1px solid #e6e6e6;
    padding: 10px 0;
  }

  .insight-filter > * {
    margin-left: 10px;
  }

  .el-dropdown-link {
    cursor: pointer;
    color: #409EFF;
  }

  .el-icon-arrow-down {
    font-size: 12px;
  }


  .member {
    display: table-row;
    font-size: 16px;
  }

  .member > * {
    display: table-cell;
    vertical-align: middle;
    padding-right: 15px;
  }

  .avatar {
    line-height: 50px;
  }

  .avatar img {
    width: 40px;
    height: 40px;
    -webkit-border-radius: 50%;
    -moz-border-radius: 50%;
    border-radius: 50%;
    vertical-align: middle;
  }

  .member-text > * {
    line-height: 1em;
  }
</style>
<style>
  .insight .echarts {
    width: 100%;
  }
</style>
