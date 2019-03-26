import Vue from 'vue/dist/vue.esm'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import ClassroomStudentService from "./classroom/services/classroom_student_service";
import AlertMixin from './shared/components/mixins/alert'

Vue.use(ElementUI);

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#show-classroom-app',
    data() {
      return {
        students: null,
        btnLoadings: null
      }
    },
    mixins: [AlertMixin],
    mounted() {
      this.students = JSON.parse(this.$el.dataset.students);
      this.btnLoadings = [];
      for (let i = 0;i < this.students.length;i++) {
        this.btnLoadings.push(false);
      }
      const endpoint = this.$el.dataset.endpoint;
      this.classroomStudentsService = new ClassroomStudentService({
        classroomStudentsEndpoint: endpoint
      })
    },
    methods: {
      deleteStudent(index, user_id) {
        this.$confirm('确认移出班级？', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.btnLoadings.splice(index, 0, true);
          this.classroomStudentsService.deleteStudent(user_id)
            .then(res => res.data)
            .then(data => {
              this.students.splice(index, 1);
              this.btnLoadings.splice(index, 0, false);
            })
        })
      }
    }
  })
})