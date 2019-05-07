class CreateTeamStates < ActiveRecord::Migration[5.2]
  def change
    create_table :team_states do |t|
      t.string :state
      t.belongs_to :team_event, index: true
      t.belongs_to :team_project, index: true

      t.timestamps
    end
  end
end
