<template>
  <div class="detail-issue" v-if="issue">
    <div>haha</div>
    <el-row :gutter="2">
      <el-col :span="14">
        <div class="up clearFloat">
          <div class="up-left hehe">
            up-left
          </div>
          <div class="up-left hehe">
            up-right
          </div>
        </div>
      </el-col>

      <el-col :span="8">
        <div class="up clearFloat">
          <div class="up-left hehe">
            up-left
          </div>
        </div>
      </el-col>


    </el-row>

  </div>
</template>

<script>
  import Issue from '../../issues/models/issue'

  export default {
    data() {
      return {
        policy: {
          title: false
        },
        validates: {
          title: [
            {required: true, message: "请填写Issues主题"}
          ]
        }
      }
    },
    components: {},
    props: {
      issue: Issue,
      index: Number
    },
    methods: {
      openPolicy(attr) {
        this.policy[attr] = true;
      },
      closePolicy(attr) {
        this.policy[attr] = false;
      },
      update(attr) {
        if (this.validate(attr)) {
          this.closePolicy(attr);
        }
      },
      validate(attr) {
        let validators = this.validates[attr];
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
      }
    }
  }
</script>
<style>
  .detail-issue {
    padding: 20px;
  }

  .align {
    padding-left: 15px;
  }

  .hehe {
    width: 200px;
    height: 200px;
    background: red;
    border: 1px solid #fff;
  }

  .up-left {
    float: left;
  }

</style>