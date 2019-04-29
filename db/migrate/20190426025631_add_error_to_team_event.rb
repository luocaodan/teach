class AddErrorToTeamEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :team_events, :error, :string
  end
end
