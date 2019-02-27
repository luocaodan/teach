import axios from 'axios'

export default class BlogsService {
  constructor({blogsEndpoint}) {
    this.blogsEndpoint = blogsEndpoint;
  }

  all(params) {
    return axios.get(this.blogsEndpoint, {
      params: params
    });
  }

  newBlog(blog) {
    return axios.post(this.blogsEndpoint, {
      blog: blog
    });
  }

  getBlogCode(projectId, blogId) {
    let index = this.blogsEndpoint.lastIndexOf('.json');
    let prefix = this.blogsEndpoint.substr(0, index);
    return axios.get(`${prefix}/${blogId}/raw`, {
      params: {
        project_id: projectId
      }
    });
  }

  updateBlog(projectId, blogId, update) {
    let index = this.blogsEndpoint.lastIndexOf('.json');
    let prefix = this.blogsEndpoint.substr(0, index);
    return axios.put(`${prefix}/${blogId}.json`, {update: update}, {
      params: {
        project_id: projectId
      }
    });
  }

  deleteBlog(projectId, blogId) {
    let index = this.blogsEndpoint.lastIndexOf('.json');
    let prefix = this.blogsEndpoint.substr(0, index);
    return axios.delete(`${prefix}/${blogId}.json`, {
      params: {
        project_id: projectId
      }
    });
  }
}