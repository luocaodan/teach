<template>
  <div class="detail-sprint" v-if="sprint">
    <div class="sprint-title">
      <el-row>
        <el-col :span="16">
          <el-input
            id="sprint-title"
            class="big-label"
            v-if="policy.title"
            v-model="sprint.title"
            @blur="update('title')"></el-input>
          <label class="big-label" v-else @click="openPolicy('title')">{{ sprint.title }}</label>
        </el-col>
        <el-col :span="8" class="clearFloat">
          <el-button style="width: auto;float: right" v-if="sprint.state === 'closed'" @click="update('activate')">
            Reopen
          </el-button>
          <el-button style="width: auto;float: right" v-else type="danger" @click="update('close')">Close</el-button>
        </el-col>
      </el-row>
    </div>
    <div class="sprint-description">
      <div class="block-title">
        <span>冲刺描述</span>
        <i class="el-icon-edit title-icon" @click="openPolicy('description')"></i>
      </div>
      <div class="block-value">
        <md-wrapper v-if="policy.description || sprint.description"
                    v-model="sprint.description"
                    :min-height="200" :border="false"
                    :box-shadow="false"
                    :project-id="sprint.projectId"
                    func="mini"
                    @save="update('description')"
                    :preview="!policy.description">
        </md-wrapper>
        <p v-else>
          无冲刺描述
        </p>
      </div>
    </div>
    <div class="sprint-date">
      <div class="block-title">
        <span>日期</span>
        <i class="el-icon-date title-icon"></i>
      </div>
      <el-row class="block-value">
        <el-col :span="12">
          <span>
            开始日期：
          </span>
          <el-date-picker
            size="mini"
            v-model="sprint.start_date"
            align="right"
            type="date"
            value-format="yyyy-MM-dd"
            placeholder="选择日期"
            @change="update('start_date')"
            :picker-options="pickerOptions">
          </el-date-picker>
        </el-col>
        <el-col :span="12">
          <span>
            截止日期：
          </span>
          <el-date-picker
            size="mini"
            v-model="sprint.due_date"
            align="right"
            type="date"
            value-format="yyyy-MM-dd"
            placeholder="选择日期"
            @change="update('due_date')"
            :picker-options="pickerOptions">
          </el-date-picker>
        </el-col>
      </el-row>
    </div>
    <div class="block-title">
      <span>燃尽图</span>
      <i class="iconfont icon-burndowncharticon title-icon"></i>
    </div>
  </div>
</template>

<script>
  import DateMixin from '../../shared/components/mixins/date_support'
  import eventhub from '../../issues/eventhub'
  import Sprint from '../../burndown/models/sprint'
  import mdWrapper from '../../shared/components/md_wrapper.vue'

  export default {
    updated() {
      if (this.sprint.isCome) {
        this.rawSprint = Object.assign({}, this.sprint);
        this.sprint.isCome = false;
      }
    },
    mixins: [DateMixin],
    components: {
      mdWrapper
    },
    data() {
      return {
        policy: {
          title: false,
          description: false,
        }
      }
    },
    props: {
      sprint: Sprint
    },
    methods: {
      openPolicy(attr) {
        this.policy[attr] = true;
        if (attr === 'title') {
          setTimeout(() => {
            document.getElementById('sprint-' + attr).focus();
          }, 0);
        }
      },
      update(attr) {
        if (!['activate', 'close'].includes(attr) && this.sprint[attr] === this.rawSprint[attr]) {
          this.policy[attr] = false;
          return;
        }
        let value = this.sprint[attr];
        if (['activate', 'close'].includes(attr)) {
          value = attr;
          attr = 'state_event';
        }
        const update = {};
        update[attr] = value;
        eventhub.$emit('updateSprint', update);
        this.policy[attr] = false;
      },
    }
  }
</script>

<style scoped>
  .detail-sprint > * {
    margin: 20px 0;
  }

  .big-label {
    font-size: 26px;
    font-weight: 600;
  }

  .block-title {
    font-size: 16px;
    border-bottom: 1px solid #e6e6e6;
    padding-bottom: 10px;
  }

  .title-icon {
    padding: 5px;
  }

  .block-value {
    margin: 1em 0;
  }
</style>