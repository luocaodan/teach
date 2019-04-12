class CreateContributionIssues < ActiveRecord::Migration[5.2]
  def change
    create_table :contribution_issues do |t|
      t.references :issue, foreign_key: true
      t.references :team_project, foreign_key: true
      t.timestamp :closed_at
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
