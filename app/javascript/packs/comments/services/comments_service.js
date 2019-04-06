import axios from 'axios'
import Endpoint from "../../tools/endpoint";

export default class CommentsService {
  constructor({commentsEndpoint}) {
    this.commentsEndpoint = commentsEndpoint;
  }

  getComments() {
    return axios.get(this.commentsEndpoint);
  }

  newComment(comment) {
    return axios.post(this.commentsEndpoint, {
      comment
    });
  }

  updateComment(commentId, update) {
    const prefix = Endpoint.getPrefix(this.commentsEndpoint);
    return axios.put(`${prefix}/${commentId}.json`, {
      update
    });
  }

  deleteComment(commentId) {
    const prefix = Endpoint.getPrefix(this.commentsEndpoint);
    return axios.delete(`${prefix}/${commentId}.json`);
  }
}