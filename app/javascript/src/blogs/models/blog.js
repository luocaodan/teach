export default class Blog {
  constructor(type) {
    if (type === 'blog') {
      this.file_name = 'blog.md';
    }
    else {
      this.file_name = 'daily_scrum.md';
    }
    this.project_id = null;
    this.title = '';
    this.description = '';
    this.code = '';
  }
}