import axios from 'axios'

export default class CommentsService {
  constructor({commentsEndpoint}) {
    this.commentsEndpoint = commentsEndpoint;
  }

  getComments() {
    return axios.get(this.commentsEndpoint);
  }
}