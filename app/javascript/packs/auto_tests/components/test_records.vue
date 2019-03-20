<template>
  <div class="test-records">
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
    </el-table>
  </div>
</template>
<script>
  import TestRecord from "../models/test_record";

  export default {
    data() {
      return {
        records: []
      }
    },
    mounted() {
      const $recordApp = document.getElementById('test-records')
      const records = JSON.parse($recordApp.dataset.records)
      const testRecords = []
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
    width: 80%;
    margin: 0 auto;
  }
</style>