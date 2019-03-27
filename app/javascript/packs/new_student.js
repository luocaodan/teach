import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import AlertMixin from './shared/components/mixins/alert'
import ClassroomStudentService from './classroom/services/classroom_student_service'

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#new-student-app',
    data() {
      return {
        students: null,
        btnLoadings: null,
      }
    },
    mixins: [AlertMixin],
    mounted() {
      this.students = JSON.parse(this.$el.dataset.students);
      this.btnLoadings = [];
      for (let i = 0;i < this.students.length;i++) {
        this.btnLoadings.push(false)
      }
      const endpoint = this.$el.dataset.endpoint;
      this.classroomStudentsService = new ClassroomStudentService({
        classroomStudentsEndpoint: endpoint
      })
    },
    methods: {
      addBtnType(added) {
        return added? 'plain': 'success'
      },
      addBtnText(added) {
        return added? '已添加': '添加'
      },
      addStudent(index, user_id, username) {
        this.btnLoadings.splice(index, 1, true);
        this.classroomStudentsService.addStudent(user_id, username)
          .then(res => res.data)
          .then(data => {
            const students = this.students;
            students[index]['added'] = true;
            this.students = students;
            this.btnLoadings.splice(index, 1, false);
          })
          .catch(e => {
            this.btnLoadings.splice(index, 1, false);
            this.alert('添加失败');
          })
      },
    }
  })
})