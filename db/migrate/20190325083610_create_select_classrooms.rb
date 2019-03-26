class CreateSelectClassrooms < ActiveRecord::Migration[5.2]
  def change
    create_table :select_classrooms do |t|
      t.belongs_to :user, index: true
      t.belongs_to :classroom, index: true

      t.timestamps
    end
  end
end
