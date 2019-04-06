class CreateBlogs < ActiveRecord::Migration[5.2]
  def change
    create_table :blogs do |t|
      t.integer :gitlab_id
      t.integer :project_id
      t.string :type

      t.timestamps
    end
  end
end
