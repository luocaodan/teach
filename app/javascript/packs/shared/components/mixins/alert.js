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
    }
  }
}