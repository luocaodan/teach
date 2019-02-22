import axios from 'axios'

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
    let index = this.sprintsEndpoint.lastIndexOf('.json');
    let prefix = this.sprintsEndpoint.substr(0, index);
    return axios.get(`${prefix}/${id}.json`, {
      params: {
        project_id: projectId,
        milestone_id: id
      }
    });
  }
}