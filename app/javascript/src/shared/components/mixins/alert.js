// 设置显示时间为 1s
const duration = 1000;

const AlertMixin = {
  methods: {
    alert(msg, type = 'error') {
      this.$message({
        message: msg,
        type: type,
        duration: duration
      });
    },
    success(msg) {
      this.$message({
        message: msg,
        type: 'success',
        duration: duration
      })
    },
    warn(msg) {
      this.$message({
        message: msg,
        type: 'warning',
        duration: duration
      })
    },
    notify(msg) {
      this.$notify.info({
        title: '提示',
        message: msg,
        duration: duration
      });
    }
  }
}
export default AlertMixin;