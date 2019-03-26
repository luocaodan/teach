import axios from 'axios'

export default class ClassroomStudentService {
  constructor({classroomStudentsEndpoint}) {
    this.classroomStudentsEndpoint = classroomStudentsEndpoint;
  }

  addStudent(user_id) {
    return axios.post(this.classroomStudentsEndpoint, {
      user: user_id
    })
  }

  deleteStudent(user_id) {
    return axios.delete(`${this.classroomStudentsEndpoint}/${user_id}`)
  }
}