import axios from 'axios'

export default class ClassroomStudentService {
  constructor({classroomStudentsEndpoint}) {
    this.classroomStudentsEndpoint = classroomStudentsEndpoint;
  }

  addStudent(user_id, username) {
    return axios.post(this.classroomStudentsEndpoint, {
      user_id: user_id,
      username: username
    })
  }

  deleteUser(user_id, type) {
    return axios.delete(`${this.classroomStudentsEndpoint}/${user_id}?type=${type}`)
  }
}