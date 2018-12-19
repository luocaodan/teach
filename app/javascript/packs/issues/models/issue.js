class Issue {
  constructor() {
    this.id = '';

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
      let camelKey = this.toCamelCase(key);
      if (res[camelKey] !== undefined) {
        res[camelKey] = obj[key];
      }
    }
    return res;
  }

  static toCamelCase(name) {
    let camel = name.replace(/\_(\w)/g, (match, group) => {
      return group.toUpperCase();
    });
    return camel;
  }

  static toUnderLine(name) {
    return name.replace(/([A-Z])/g, '_$1').toLowerCase();
  }
}

export default Issue;