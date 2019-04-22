<template>
  <div class="test-records small-container">
    <el-table
      :data="records"
      style="width: 100%"
      :default-sort="{prop: 'cost', order: 'ascending'}">
      <el-table-column type="expand">
        <template slot-scope="props">
          <el-tabs type="border-card">
            <el-tab-pane label="单元测试">
              <el-table
                :data="props.row.unitTests"
                :row-class-name="testResultClass"
                max-height="250">
                <el-table-column
                  label="测试名"
                  prop="name">
                </el-table-column>
                <el-table-column
                  label="状态"
                  prop="passed"
                  :formatter="testResultFmt">
                </el-table-column>
              </el-table>
            </el-tab-pane>
            <el-tab-pane label="正确性测试">
              <el-table
                :data="props.row.corrects"
                :row-class-name="testResultClass"
                max-height="250">
                <el-table-column
                  label="测试用例"
                  prop="testcase">
                </el-table-column>
                <el-table-column
                  label="状态"
                  prop="passed"
                  :formatter="testResultFmt">
                </el-table-column>
                <el-table-column
                  label="结果"
                  prop="res">
                </el-table-column>
              </el-table>
            </el-tab-pane>
            <el-tab-pane label="鲁棒性测试">
              <el-table
                :data="props.row.wrongs"
                :row-class-name="testResultClass"
                max-height="250">
                <el-table-column
                  label="测试用例"
                  prop="testcase">
                </el-table-column>
                <el-table-column
                  label="状态"
                  prop="passed"
                  :formatter="testResultFmt">
                </el-table-column>
                <el-table-column
                  label="结果"
                  prop="res">
                </el-table-column>
              </el-table>
            </el-tab-pane>
            <el-tab-pane>
              <span slot="label">
                教师反馈
                <i class="el-icon-edit icon-button"
                   v-if="props.row.editable"
                   @click="editFeedback(props.$index)"></i>
              </span>
              <p v-if="isPreview(props.$index) && !props.row.feedback">
                暂无反馈
              </p>
              <md-wrapper v-model="props.row.feedback"
                          :border="false" :box-shadow="false"
                          :project-id="props.row.project_id"
                          :project-url="props.row.project_url"
                          func="mini"
                          @save="saveFeedback(props.row.id, props.row.feedback)"
                          :preview="!props.row.editable || isPreview(props.$index)">
              </md-wrapper>
            </el-tab-pane>
          </el-tabs>
        </template>
      </el-table-column>
      <el-table-column
        label="学号"
        prop="student"
        align="center">
      </el-table-column>
      <el-table-column
        label="单元测试"
        prop="unitTestsSummary"
        align="center">
      </el-table-column>
      <el-table-column
        label="正确性测试"
        prop="correctsSummary"
        align="center">
      </el-table-column>
      <el-table-column
        label="鲁棒性测试"
        prop="wrongsSummary"
        align="center">
      </el-table-column>
      <el-table-column
        label="耗时/秒"
        prop="cost"
        align="center"
        :formatter="doubleFmt"
        sortable
        :sort-method="compareRecord">
      </el-table-column>
      <el-table-column
        label="性能排名"
        prop="rank"
        align="center">
      </el-table-column>
      <el-table-column>
        <template slot-scope="scope">
          <div v-if="scope.row.editable">
          <span v-if="scope.row.status === 'running'">
            <el-button type="danger" size="mini"
                       @click="triggerCI(scope.$index, scope.row.id, 'cancel')">
              Cancel CI
            </el-button>
          </span>
            <el-button v-else type="primary" size="mini"
                       @click="triggerCI(scope.$index, scope.row.id, 'start')">
              Start CI
            </el-button>
          </div>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>
<script>
  import TestRecord from "../models/test_record";
  import mdWrapper from '../../shared/components/md_wrapper.vue'
  import AlertMixin from '../../shared/components/mixins/alert'
  import axios from 'axios'

  export default {
    data() {
      return {
        records: [],
        currentRecordIndex: null,
        loading: false
      }
    },
    mixins: [AlertMixin],
    components: {
      mdWrapper
    },
    mounted() {
      const records = JSON.parse(this.$el.dataset.records);
      const testRecords = [];
      for (let record of records) {
        const tr = TestRecord.valueOf(record);
        testRecords.push(tr);
      }
      testRecords.sort((a, b) => {
        return this.compareRecord(a, b);
      });
      for (let i = 0; i < testRecords.length; i++) {
        if (isNaN(testRecords[i].cost)) {
          testRecords[i].rank = '无';
          break;
        }
        testRecords[i].rank = `${i + 1}/${testRecords.length}`;
      }
      this.records = testRecords;
    },
    methods: {
      testResultFmt(row, column, cellValue, index) {
        if (row.passed === true) {
          return "Success";
        }
        return "Fail";
      },
      testResultClass({row, rowIndex}) {
        if (row.passed === true) {
          return 'success-row';
        }
        return 'error-row';
      },
      compareRecord(a, b) {
        if (isNaN(b.cost)) {
          return -1;
        }
        if (isNaN(a.cost)) {
          return 1;
        }
        return a.cost - b.cost;
      },
      doubleFmt(row) {
        if (isNaN(row.cost)) {
          return row.cost;
        }
        return Math.round(row.cost * 1000) / 1000;
      },
      isPreview(index) {
        return this.currentRecordIndex !== index;
      },
      editFeedback(index) {
        this.currentRecordIndex = index;
      },
      saveFeedback(testRecordId, feedback) {
        const endpoint = this.$el.dataset.endpoint;
        this.loading = true;
        axios.post(`${endpoint}/feedback.json`, {
          test_record_id: testRecordId,
          feedback: feedback
        })
          .then(res => res.data)
          .then(data => {
            this.currentRecordIndex = null;
            this.loading = false;
          })
          .catch(e => {
            this.alert('保存反馈失败');
          })
      },
      triggerCI(recordIndex, testRecordId, action) {
        const endpoint = this.$el.dataset.endpoint;
        const tmp = this.records[recordIndex].status;
        if (action === 'start') {
          this.records[recordIndex].status = 'running';
        } else {
          this.records[recordIndex].status = 'stop';
        }
        axios.post(`${endpoint}/trigger.json`, {
          test_record_id: testRecordId,
          trigger: action
        })
          .catch(e => {
            this.records[recordIndex].status = tmp;
            this.alert('Trigger Fail!')
          })
      }
    }
  }
</script>
<style>
  .el-table .success-row {
    background: #f0f9eb;
  }

  .el-table .error-row {
    background: oldlace;
  }
</style>

<style scoped>
  .test-records {
    min-width: 600px;
  }
</style>