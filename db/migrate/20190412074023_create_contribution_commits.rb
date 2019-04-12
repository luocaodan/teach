class CreateContributionCommits < ActiveRecord::Migration[5.2]
  def change
    create_table :contribution_commits do |t|
      t.string :gitlab_id
      t.references :team_project, foreign_key: true
      t.timestamp :committed_at
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
