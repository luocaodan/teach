class ChangeRelationOfContributionIssueAndIssue < ActiveRecord::Migration[5.2]
  def change
    remove_reference :contribution_issues, :issue, foreign_key: true
    add_reference :issues, :contribution_issue
  end
end
