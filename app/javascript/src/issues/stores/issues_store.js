const issuesStore = {
  debug: false,
  state: {
    labels: [],
    members: []
  },
  setLabelsAction (newValue) {
    if (this.debug)
      console.log('setLabelsAction triggered with', newValue)
    this.state.labels = newValue
  },
  setMembersAction (newValue) {
    if (this.debug)
      console.log('setMembersAction triggered with', newValue)
    this.state.members = newValue
  },
}

export default issuesStore