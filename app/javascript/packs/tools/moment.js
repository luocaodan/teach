import moment from 'moment'

export default class Moment {
  static dateStr(utcStr) {
    return moment(utcStr).format('YYYY-MM-DD');
  }

  static timeStr(utcStr) {
    return moment(utcStr).format('YYYY-MM-DD HH:mm:ss');
  }
}