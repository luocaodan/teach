import axios from 'axios'

export default class UploadService {
  static upload(projectId, formdata) {
    let uploadUrl = `/projects/${projectId}/uploads.json`;
    return axios({
      url: uploadUrl,
      method: 'post',
      data: formdata,
      headers: {'Content-Type': 'multipart/form-data'},
    })
  }
}