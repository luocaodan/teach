<template>
  <div class="detail-issue" v-if="issue">
    <div class="issue-title">
      <el-row>
        <el-col :span="16">
          <el-input class="big-label" id="issue-title" v-if="policy.title" v-model="issue.title"
                    @blur="update('title')"></el-input>
          <label class="big-label" v-else @click="openPolicy('title')">{{ issue.title }}</label>
        </el-col>
        <el-col :span="6" :offset="2">
          <el-button style="width: auto" v-if="issue.state === 'Closed'" @click="update('Open')">
            Reopen
          </el-button>
          <el-button style="width: auto" v-else type="danger" @click="update('Closed')">Close</el-button>
        </el-col>
      </el-row>
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
                <el-tag size="mini" :type="stateType(issue.state)">
                  {{ issue.state }}
                </el-tag>
                <el-button
                  style="margin: 4px"
                  icon="el-icon-circle-plus"
                  v-if="issue.state === 'Open' && canEdit"
                  title="添加到待办"
                  @click="update('To Do')"
                  size="mini" circle></el-button>
            </span>
          </div>
          <div class="clearFloat">
            <span class="info-attr">权重：</span>
            <el-input
              size="mini" class="info-value"
              id="issue-weight" v-if="policy.weight"
              v-model.number="issue.weight"
              @blur="update('weight')">
            </el-input>
            <span v-else @click="openPolicy('weight')" class="info-value">
                <span v-if="issue.weight">
                  {{ issue.weight }}
                </span>
                <span v-else>
                  无
                </span>
              </span>
          </div>
          <div class="clearFloat" style="clear: left">
            <span class="info-attr">优先级：</span>
            <el-select id="issue-priority" v-if="canEdit" size="mini" class="info-value" v-model="issue.priority"
                       @change="update('priority')">
              <el-option label="高" :value="3"></el-option>
              <el-option label="中" :value="2"></el-option>
              <el-option label="低" :value="1"></el-option>
            </el-select>
            <span v-else class="info-value">
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
              <span v-if="canEdit">
                <el-select
                  size="mini"
                  v-model="issue.milestone.id"
                  @change="update('milestone')"
                  placeholder="选择冲刺">
                  <el-option label="无冲刺" :value="0"></el-option>
                  <el-option v-for="(milestone, index) in milestones"
                             :key="index" :label="milestone.title"
                             :value="milestone.id"></el-option>
                </el-select>
              </span>
              <span v-else class="info-value">
                <span v-if="issue.milestone.id">
                  <a :href="issue.milestone.webUrl" target="_blank">
                    {{ issue.milestone.title }}
                  </a>
                </span>
                <span v-else>
                  无
                </span>
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
            <el-select class="info-value"
                       size="mini" v-if="canEdit"
                       v-model="issue.labels" multiple
                       placeholder="选择标签"
                       @change="update('labels')">
              <el-option v-for="(label, index) in labels"
                         :key="index" :label="label.name"
                         :value="label.name"></el-option>
            </el-select>
            <span class="info-value" v-else @click="openPolicy('labels')">
              <span v-if="issue.labels.length">
                <el-tag style="margin: 3px" size="mini" v-for="(label, index) in issue.labels"
                        :key="index">{{ label }}</el-tag>
              </span>
              <span v-else>
                无
              </span>
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
            <span v-if="canEdit" style="display:inline-block; width: 50%">
              <el-select
                size="mini"
                v-model="issue.assignee.id"
                @change="update('assignee')"
                placeholder="选择经办人">
                <el-option label="无经办人" :value="0"></el-option>
                <el-option
                  v-for="(member, index) in members"
                  :key="index"
                  :label="member.name"
                  :value="member.id">
                  <span>
                    <img style="height: 13px;width:13px;display:inline" :src="member.avatar">
                    {{ member.name }}
                  </span>
                </el-option>
              </el-select>
            </span>
            <span class="info-value" v-else>
              <span v-if="issue.assignee.id">
                <el-popover
                  placement="top-start"
                  title="经办人"
                  width="200"
                  trigger="hover">
                  <div>
                    <a :href="issue.assignee.webUrl" target="_blank">
                      {{ issue.assignee.name }}
                    </a>
                  </div>
                  <div>
                    @{{ issue.assignee.username}}
                  </div>

                  <span slot="reference">
                    <img style="height: 13px;width:13px;display:inline" :src="issue.assignee.avatar">
                    {{ issue.assignee.name }}
                  </span>
                </el-popover>

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
              <el-popover
                placement="top-start"
                title="报告人"
                width="200"
                trigger="hover">
                  <div>
                    <a :href="issue.author.web_url" target="_blank">
                      {{ issue.author.name }}
                    </a>
                  </div>
                  <div>
                    @{{ issue.author.username}}
                  </div>

                  <span slot="reference">
                    <img style="height: 13px;width:13px;" :src="issue.author.avatar_url">
                    {{ issue.author.name }}
                  </span>
                </el-popover>
            </span>
          </div>
        </div>
      </div>

      <div class="up-left description-info">
        <div class="block-title">
          <span>问题描述</span>
          <i class="el-icon-edit description-edit" @click="openPolicy('description')"></i>
        </div>
        <div class="info-list clearFloat">

          <md-wrapper id="issue-description"
                      v-if="policy.description || issue.description"
                      v-model="issue.description"
                      :border="false" :box-shadow="false"
                      :project-id="issue.projectId"
                      func="mini" :style="{width: '100%'}"
                      @save="update('description')"
                      :preview="!policy.description">
          </md-wrapper>
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
              创建日期：
            </span>
            <span class="info-value">
              <i class="el-icon-date"></i>
              {{ dateText(issue.createdAt) }}
            </span>
          </div>
          <div class="clearFloat">
            <span class="info-attr">
              更新日期：
            </span>
            <span class="info-value">
              <i class="el-icon-date"></i>
              {{ dateText(issue.updatedAt) }}
            </span>
          </div>
          <div class="clearFloat">
            <span class="info-attr">
              截止日期：
            </span>
            <el-date-picker class="info-value" v-if="canEdit"
                            size="mini"
                            v-model="issue.dueDate"
                            align="right"
                            type="date"
                            value-format="yyyy-MM-dd"
                            placeholder="选择日期"
                            @change="update('dueDate')"
                            :picker-options="pickerOptions">
            </el-date-picker>
            <span v-else>
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
  import eventhub from '../../issues/eventhub'
  import Transform from '../../tools/transform'
  import AlertMixin from './mixins/alert'
  import DateMixin from './mixins/date_support'
  import mdWrapper from './md_wrapper.vue'
  import Moment from "../../tools/moment";
  import issuesStore from "../../issues/stores/issues_store";

  export default {
    mixins: [AlertMixin, DateMixin],
    data() {
      return {
        policy: {
          title: false,
          weight: false,
          description: false,
        },
        validates: {
          title: [
            {required: true, message: "请填写Issues主题"},
          ],
          weight: [
            {type: 'integer', message: '权重必须为数字'},
            {min: 1, message: "权重至少为1"},
            {max: 20, message: "权重最大为20"}
          ]
        },
      }
    },
    computed: {
      labels() {
        return issuesStore.state.labels.filter((l) => !['To Do', 'Doing'].includes(l.name));
      },
      members() {
        return issuesStore.state.members;
      },
      milestones() {
        const $navbar = document.getElementById('navbar');
        const projects = JSON.parse($navbar.dataset.projects);
        return projects.find((p) => p.id === this.issue.projectId).milestones;
      },
      canEdit() {
        return true;
      }
    },
    components: {
      mdWrapper
    },
    props: {
      issue: Issue,
      issueDup: Issue,
    },
    methods: {
      openPolicy(attr) {
        if (!this.canEdit) {
          return;
        }
        this.policy[attr] = true;
        setTimeout(() => {
          document.getElementById('issue-' + attr).focus();
        }, 0);
      },
      closePolicy(attr) {
        if (this.policy[attr]) {
          this.policy[attr] = false;
        }
      },
      update(attr) {
        if (!['Closed', 'Open', 'To Do'].includes(attr) && this.unchange(attr)) {
          this.closePolicy(attr);
          return;
        }
        if (this.validate(attr)) {
          let value = this.issue[attr];
          if (['assignee', 'milestone'].includes(attr)) {
            value = this.issue[attr].id;
          } else if (attr === 'labels') {
            if (['To Do', 'Doing'].includes(this.issue.state)) {
              value = this.issue.labels.concat(this.issue.state);
            }
          } else if (['Closed', 'Open', 'To Do'].includes(attr)) {
            // 更新值加上其他labels
            value = attr;
            if (attr === 'To Do') {
              value = this.issue.labels.concat(value);
            }
            attr = 'state';
          }
          eventhub.$emit('updateIssue', {
            id: this.issue.id,
            project_id: this.issue.projectId,
            iid: this.issue.iid,
            attr: Transform.toUnderLine(attr),
            value: value
          });
          this.closePolicy(attr);
        }
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
          if (validator.type === 'integer') {
            if (!Number.isInteger(this.issue[attr])) {
              this.alert(msg);
              return false;
            }
          }
          if (validator.min) {
            if (this.issue[attr] < validator.min) {
              this.alert(msg);
              return false;
            }
          }
          if (validator.max) {
            if (this.issue[attr] > validator.max) {
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
        return list[priority - 1];
      },
      dateText(utcStr) {
        return Moment.dateStr(utcStr);
      },
      unchange(attr) {
        if (attr === 'labels') {
          let listA = this.issue[attr];
          let listB = this.issueDup[attr];
          if (listA.length === listB.length) {
            for (let i = 0; i < listA.length; i++) {
              if (listA[i] !== listB[i]) {
                return false;
              }
            }
            return true;
          }
          return false;
        } else if (['assignee', 'milestone'].includes(attr)) {
          return this.issue[attr].id === this.issueDup[attr].id;
        } else {
          return this.issue[attr] === this.issueDup[attr];
        }
      },
      stateType(state) {
        if (state === 'Closed') {
          return 'success';
        } else if (state === 'Doing') {
          return 'warning';
        }
        return 'danger';
      }
    }
  }
</script>
<style scoped>
  .detail-issue {
    padding: 20px;
  }

  .big-label {
    font-size: 26px;
    font-weight: 600;
  }

  .big-label > input {
    height: 60px;
  }

  .up-left {
    float: left;
    margin: 10px;
  }

  .detail-info {
    max-width: 530px;
  }

  .description-info {
    max-width: 530px;
    clear: left;
    width: 100%;
  }

  .user-info {
    max-width: 250px;
  }

  .user-info .info-attr {
    width: 40%;
  }

  .user-info .info-value {
    width: 60%;
  }

  .date-info {
    max-width: 250px;
  }

  .info-list {
    padding: 15px;
  }

  .info-list > div {
    float: left;
    width: 250px;
    margin: 5px 0;
    font-size: 16px;
  }

  .info-attr {
    text-align: left;
    display: inline-block;
    float: left;
    width: 40%;
  }

  .info-value {
    display: inline-block;
    width: 50%
  }

  .block-title {
    font-size: 16px;
    border-bottom: 1px solid #e6e6e6;
    padding-bottom: 10px;
  }

  .issue-title {
    margin-bottom: 20px;
  }

  .description-edit {
    padding: 5px;
  }

  .description-edit:hover {
    background-color: #e6e6e6;
    border-radius: 3px;
    cursor: pointer;
  }

</style>