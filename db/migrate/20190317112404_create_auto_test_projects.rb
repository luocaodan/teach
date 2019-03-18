class CreateAutoTestProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :auto_test_projects do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
