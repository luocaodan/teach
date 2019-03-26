class CreateClassrooms < ActiveRecord::Migration[5.2]
  def change
    create_table :classrooms do |t|
      t.string :name
      t.string :path
      t.string :description
      # gitlab group id
      t.integer :gitlab_group_id
      t.timestamps
    end
  end
end
