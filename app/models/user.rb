class User < ApplicationRecord
  has_many :select_classrooms
  has_many :classrooms, through: :select_classrooms
  has_many :student_test_records
  has_many :blogs
end
