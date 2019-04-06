class RenameReservedFieldOfBlogs < ActiveRecord::Migration[5.2]
  def change
    remove_column :blogs, :type, :string
    add_column :blogs, :blog_type, :string
  end
end
