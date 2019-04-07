import axios from 'axios'
import Endpoint from "../../tools/endpoint";

export default class IssuesService {
  constructor({issuesEndpoint}) {
    this.issuesEndpoint = issuesEndpoint;
  }

  all(filterParams = {}, isFull = false) {
    if (isFull) {
      // 不分页 返回全量数据
      const prefix = Endpoint.getPrefix(this.issuesEndpoint);
      return axios.get(`${prefix}/all.json`, {
        params: filterParams
      })
    }
    else {
      return axios.get(this.issuesEndpoint, {
        params: filterParams
      });
    }
  }

  newIssue(issue) {
    return axios.post(this.issuesEndpoint, {
      issue: issue
    });
  }

  updateIssue(update) {
    let prefix = Endpoint.getPrefix(this.issuesEndpoint);
    return axios.put(`${prefix}/${update.iid}.json`, {
      update_issue: update
    });
  }
}