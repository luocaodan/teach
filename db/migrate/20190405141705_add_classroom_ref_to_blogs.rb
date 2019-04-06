class AddClassroomRefToBlogs < ActiveRecord::Migration[5.2]
  def change
    add_reference :blogs, :classroom, foreign_key: true
  end
end
