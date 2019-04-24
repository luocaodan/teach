export default {
  methods: {
    alert(msg, type = 'error') {
      if (type === 'error') {
        this.$message.error(msg);
      }
      else {
        this.$message({
          message: msg,
          type: type
        });
      }
    },
    success(msg) {
      this.$message({
        message: msg,
        type: 'success'
      })
    },
    warn(msg) {
      this.$message({
        message: msg,
        type: 'warning'
      })
    },
    notify(msg) {
      this.$notify.info({
        title: '提示',
        message: msg
      });
    }
  }
}