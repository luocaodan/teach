<template>
  <div class="detail-issue" v-if="issue">
    <div class="issue-title">
      <el-input class="big-label" id="issue-title" v-if="policy.title" v-model="issue.title"
                @blur="update('title')"></el-input>
      <label class="align big-label" v-else @click="openPolicy('title')">{{ issue.title }}</label>
    </div>
    <div class="clearFloat">
      <div class="up-left detail-info">
        <div class="block-title">
          <span>问题详情</span>
        </div>
        <div class="info-list clearFloat">
          <div class="clearFloat">
            <span class="info-attr">状态：</span>
            <span class="info-value">
                <el-tag size="mini">
                  {{ issue.state }}
                </el-tag>
              </span>
          </div>
          <div class="clearFloat">
            <span class="info-attr">权重：</span>
            <el-input size="mini" class="info-value" id="issue-weight" v-if="policy.weight" v-model="issue.weight" @blur="update('weight')"></el-input>
            <span v-else @click="openPolicy('weight')" class="info-value">
                <span v-if="issue.weight">
                  {{ issue.weight }}
                </span>
                <span v-else>
                  无
                </span>
              </span>
          </div>
          <div class="clearFloat">
            <span class="info-attr">优先级：</span>
            {{ issue.weight }}
            <el-select id="issue-priority" v-if="policy.priority" size="mini" class="info-value" v-model="issue.weight" @click="test" @blur="update('priority')">
              <el-option label="高" :value="5"></el-option>
              <el-option label="中" :value="2"></el-option>
              <el-option label="低" :value="1"></el-option>
            </el-select>
            <span v-else class="info-value" @click="openPolicy('priority')">
                <span v-if="issue.priority">
                  {{ priorityMap(issue.priority) }}
                </span>
                <span v-else>
                  无
                </span>
              </span>
          </div>
          <div class="clearFloat">
            <span class="info-attr">冲刺：</span>
            <span class="info-value">
                <span v-if="issue.milestone">
                  {{ issue.milestone }}
                </span>
                <span v-else>
                  无
                </span>
              </span>
          </div>
          <div class="clearFloat" style="clear: left">
            <span class="info-attr">链接：</span>
            <span class="info-value">
                <a :href="issue.webUrl" target="_blank">{{ issueWebUrl(issue.webUrl) }}</a>
              </span>
          </div>
          <div class="clearFloat">
            <span class="info-attr">标签：</span>
            <span class="info-value">
              {{ issue.labels }}
            </span>
          </div>
        </div>


      </div>


      <div class="up-left user-info">
        <div class="block-title">
          <span>用户</span>
        </div>
        <div class="info-list clearFloat">
          <div class="clearFloat">
            <span class="info-attr">
              经办人：
            </span>
            <span class="info-value">
              <span v-if="issue.assignee">
                {{ issue.assignee }}
              </span>
              <span v-else>
                无
              </span>
            </span>
          </div>
          <div class="clearFloat">
            <span class="info-attr">
              报告人：
            </span>
            <span v-if="issue.author" class="info-value">
              {{ issue.author.name }}
            </span>
          </div>
        </div>
      </div>

      <div class="up-left description-info">
        <div class="block-title">
          <span>问题描述</span>
        </div>
        <div class="info-list clearFloat">
          <p v-if="issue.description">
            {{ issue.description }}
          </p>
          <p v-else>
            无问题描述
          </p>
        </div>
      </div>

      <div class="up-left date-info">
        <div class="block-title">
          <span>日期</span>
        </div>
        <div class="info-list clearFloat">
          <div class="clearFloat">
            <span class="info-attr">
              创建日期
            </span>
            <span class="info-value">
              {{ issue.createdAt }}
            </span>
          </div>
          <div class="clearFloat">
            <span class="info-attr">
              更新日期
            </span>
            <span class="info-value">
              {{ issue.updatedAt }}
            </span>
          </div>
          <div class="clearFloat">
            <span class="info-attr">
              截止日期
            </span>
            <span>
              <span v-if="issue.dueDate" class="info-value">
                {{ issue.dueDate }}
              </span>
              <span v-else>
                无
              </span>
            </span>
          </div>
        </div>
      </div>


    </div>

  </div>
</template>

<script>
  import Issue from '../../issues/models/issue'

  export default {
    data() {
      return {
        policy: {
          title: false,
          weight: false,
          priority: false
        },
        validates: {
          title: [
            {required: true, message: "请填写Issues主题"}
          ]
        },
      }
    },
    components: {},
    props: {
      issue: Issue,
      index: Number
    },
    computed: {},
    methods: {
      openPolicy(attr) {
        this.policy[attr] = true;
        setTimeout(() => {
          document.getElementById('issue-' + attr).focus();
        }, 0);
      },
      closePolicy(attr) {
        // this.policy[attr] = false;
      },
      update(attr) {
        this.test();
        // if (this.validate(attr)) {
        //   console.log(this.issue[attr]);
        //   this.closePolicy(attr);
        // }
      },
      validate(attr) {
        let validators = this.validates[attr];
        if (!validators) {
          return true;
        }
        for (let validator of validators) {
          const msg = validator.message;
          if (validator.required === true) {
            if (this.isEmpty(this.issue[attr])) {
              this.alert(msg);
              return false;
            }
          }
        }
        return true;
      },
      isEmpty(value) {
        if (value === 0) {
          return false;
        }
        if (value === false) {
          return false;
        }
        return !value;
      },
      alert(msg) {
        this.$alert(msg, '提示');
      },
      issueWebUrl(url) {
        if (!url) {
          return;
        }
        const pattern = /issues\/(\d+)/;
        let group = url.match(pattern);
        return '#' + group[1];
      },
      priorityMap(priority) {
        const list = ['低', '中', '高'];
        return list[priority-1];
      },
      test() {
        this.issue.weight = 2;
        console.log(this.issue);
      }
    }
  }
</script>
<style scoped>
  .detail-issue {
    padding: 20px;
    overflow-y: auto;
  }

  .big-label {
    font-size: 24px;
    height: 60px;
    line-height: 60px;
  }

  .big-label > input {
    height: 60px;
  }

  .up-left {
    float: left;
    margin: 10px;
  }

  .detail-info {
    max-width: 520px;
  }

  .description-info {
    max-width: 520px;
    clear: left;
    width: 100%;
  }

  .user-info {
    max-width: 250px;
  }

  .date-info {
    max-width: 250px;
  }

  .info-list {
    /*float: left;*/
    padding: 20px;
  }

  .info-list > div {
    float: left;
    width: 240px;
    line-height: 40px;
  }

  .info-attr {
    text-align: left;
    display: inline-block;
    float: left;
    width: 50%;
  }

  .info-value {
    display: inline-block;
    width: 40%
  }

  .block-title {
    font-size: 16px;
    border-bottom: 1px solid #e6e6e6;
    padding-bottom: 10px;
  }

  .issue-title {
    margin-bottom: 20px;
  }

</style>