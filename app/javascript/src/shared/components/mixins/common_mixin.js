import IssuesMixin from './issues_mixin'
import IssuesService from "../../../issues/services/issues_service";

export default {
  mixins: [IssuesMixin],
  mounted() {
    const issuesEndpoint = this.getIssuesEndpoint();
    this.issuesService = new IssuesService({
      issuesEndpoint: issuesEndpoint
    });
  },
  methods: {
    getIssuesEndpoint() {
      const $app = this.getContainer();
      return $app.dataset.issuesEndpoint;
    },
    belongsToMe(issue) {
      return false;
    },
    getContainer() {
      return this.$el;
    }
  }
}