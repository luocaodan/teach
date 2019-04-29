class AddStateToTeamProject < ActiveRecord::Migration[5.2]
  def change
    add_column :team_projects, :state, :string
  end
end
