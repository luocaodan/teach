import axios from 'axios'
import Endpoint from "../../tools/endpoint";

export default class IssuesService {
  constructor({sprintsEndpoint}) {
    this.sprintsEndpoint = sprintsEndpoint;
  }

  newSprint(sprint) {
    return axios.post(this.sprintsEndpoint, {
      sprint: sprint
    });
  }

  getSprint(id, projectId) {
    let prefix = Endpoint.getPrefix(this.sprintsEndpoint);
    return axios.get(`${prefix}/${id}.json`, {
      params: {
        project_id: projectId,
        milestone_id: id
      }
    });
  }

  updateSprint(id, projectId, update) {
    const prefix = Endpoint.getPrefix(this.sprintsEndpoint);
    return axios.put(`${prefix}/${id}.json`, {update: update}, {
      params: {
        project_id: projectId,
        milestone_id: id
      }
    });
  }
}