import axios from 'axios'

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
    const index = this.commentsEndpoint.lastIndexOf('.json');
    const prefix = this.commentsEndpoint.substr(0, index);
    return axios.put(`${prefix}/${commentId}.json`, {
      update
    });
  }

  deleteComment(commentId) {
    const index = this.commentsEndpoint.lastIndexOf('.json');
    const prefix = this.commentsEndpoint.substr(0, index);
    return axios.delete(`${prefix}/${commentId}.json`);
  }
}