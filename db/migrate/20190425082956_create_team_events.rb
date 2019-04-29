class CreateTeamEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :team_events do |t|
      t.string :name
      t.string :description
      t.string :code
      t.references :classroom, foreign_key: true

      t.timestamps
    end
    add_index :team_events, :name, unique: true
  end
end
