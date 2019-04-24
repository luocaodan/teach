import Transform from '../../tools/transform'

class Issue {
  constructor() {
    this.id = '';
    this.iid = '';
    this.projectId = null;

    this.title = '';
    this.projectName = '';

    this.state = '';
    this.weight = null;
    this.priority = null;
    this.milestone = {
      id: 0,
      title: null,
      webUrl: null
    };
    this.webUrl = null;
    this.labels = [];

    this.description = '';

    this.assignee = {
      id: 0,
      name: null,
      avatar: null,
      username: null
    };

    this.author = null;

    this.createdAt = null;
    this.updatedAt = null;
    this.dueDate = null;
  }

  static valueOf(obj) {
    let res = new Issue();

    for (let key in obj) {
      if (['assignee', 'milestone'].includes(key)) {
        continue;
      }
      let camelKey = Transform.toCamelCase(key);
      if (res[camelKey] !== undefined) {
        res[camelKey] = obj[key];
      }
    }
    if (obj.assignee) {
      res.assignee = {
        id: obj.assignee.id,
        name: obj.assignee.name,
        avatar: obj.assignee.avatar_url,
        username: obj.assignee.username,
        webUrl: obj.assignee.web_url
      }
    }
    if (obj.milestone) {
      res.milestone = {
        id: obj.milestone.id,
        title: obj.milestone.title,
        webUrl: obj.milestone.web_url
      }
    }
    return res;
  }

  toObj() {
    const obj = {};
    for (let key in this) {
      let underLine = Transform.toUnderLine(key);
      obj[underLine] = this[key];
    }
    obj.assignee = obj.assignee.id;
    obj.milestone = obj.milestone.id;
    return obj;
  }
}

export default Issue;