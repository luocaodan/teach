import Transform from '../../tools/transform'

class Issue {
  constructor() {
    this.id = '';
    this.iid = '';
    this.access = '';
    this.projectId = '';

    this.title = '';
    this.projectName = '';

    this.state = '';
    this.weight = null;
    this.priority = null;
    this.milestone = null;
    this.webUrl = null;
    this.labels = [];

    this.description = '';

    this.assignee = null;
    this.author = null;

    this.createdAt = null;
    this.updatedAt = null;
    this.dueDate = null;
  }

  static valueOf(obj) {
    let res = new Issue();
    res.state = obj.state;
    if (obj.labels.includes('To Do')) {
      res.state = 'To Do';
    } else if (obj.labels.includes('Doing')) {
      res.state = 'Doing';
    }

    for (let key in obj) {
      if (key === 'state') {
        continue;
      }
      let camelKey = Transform.toCamelCase(key);
      if (res[camelKey] !== undefined) {
        res[camelKey] = obj[key];
      }
    }
    if (res.assignee === null) {
      res.assignee = {
        id: 0,
        name: null,
        avatar: null,
        username: null
      };
    }
    else {
      res.assignee = {
        id: res.assignee.id,
        name: res.assignee.name,
        avatar: res.assignee.avatar_url,
        username: res.assignee.username
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
    if (['To Do', 'Doing'].includes(obj.state)) {
      obj.state = 'open';
    }
    console.log(obj);
    return obj;
  }
}

export default Issue;