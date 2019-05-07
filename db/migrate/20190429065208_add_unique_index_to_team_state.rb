class AddUniqueIndexToTeamState < ActiveRecord::Migration[5.2]
  def change
    add_index :team_states, %i[team_event_id team_project_id], unique: true
  end
end
