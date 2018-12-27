import axios from 'axios'

export default class IssuesService {
  constructor({issuesEndpoint}) {
    this.issuesEndpoint = issuesEndpoint;
  }

  all(filterParams = {}) {
    return axios.get(this.issuesEndpoint, {
      params: filterParams
    });
  }

  newIssue(issue) {
    return axios.post(this.issuesEndpoint, {
      issue: issue
    });
  }

  updateIssue(update) {
    let index = this.issuesEndpoint.lastIndexOf('.json');
    let prefix = this.issuesEndpoint.substr(0, index);
    return axios.put(`${prefix}/${update.iid}.json`, {
      update_issue: update
    });
  }
}