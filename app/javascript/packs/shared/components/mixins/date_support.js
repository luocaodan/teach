export default {
  data() {
    return {
      pickerOptions: {
        disabledDate(time) {
          return false;
          /*
          const date = new Date();
          let previousDay = date.setTime(date - 3600 * 1000 * 24);
          return time.getTime() < previousDay;
          */
        },
        shortcuts: [{
          text: '今天',
          onClick(picker) {
            picker.$emit('pick', new Date());
          }
        }, {
          text: '明天',
          onClick(picker) {
            const date = new Date();
            date.setTime(date.getTime() + 3600 * 1000 * 24);
            picker.$emit('pick', date);
          }
        }]
      }
    }
  },
}