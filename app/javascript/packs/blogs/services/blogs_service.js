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
    return axios.get(`/projects/${projectId}/blogs/${blogId}/raw`);
  }

  updateBlog(projectId, blogId, update) {
    return axios.put(`/projects/${projectId}/blogs/${blogId}.json`, {
        update: update
      }
    );
  }

  deleteBlog(projectId, blogId) {
    return axios.delete(`/projects/${projectId}/blogs/${blogId}.json`);
  }
}