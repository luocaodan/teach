class Sprint {
  constructor() {
    this.id = null;
    this.iid = null;
    this.projectId = null;
    this.state = null;
    this.title = '';
    this.description = '';
    this.start_date = '';
    this.due_date = '';
    this.isCome = false;
  }

  static valueOf(obj) {
    const res = new Sprint();
    res.id = obj.id;
    res.iid = obj.iid;
    res.projectId = obj.project_id;
    res.state = obj.state;
    res.title = obj.title;
    res.description = obj.description;
    res.start_date = obj.start_date;
    res.due_date = obj.due_date;
    return res;
  }
}

export default Sprint;