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
}