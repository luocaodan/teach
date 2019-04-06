import axios from 'axios'
import Endpoint from "../../tools/endpoint";

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

  getBlogCode(blogId) {
    const prefix = Endpoint.getPrefix(this.blogsEndpoint);
    return axios.get(`${prefix}/${blogId}/raw`);
  }

  updateBlog(blogId, update) {
    const prefix = Endpoint.getPrefix(this.blogsEndpoint);
    return axios.put(`${prefix}/${blogId}.json`, {
        update: update
      }
    );
  }

  deleteBlog(blogId) {
    const prefix = this.blogsEndpoint.substr(0, index);
    return axios.delete(`${prefix}/${blogId}.json`);
  }
}