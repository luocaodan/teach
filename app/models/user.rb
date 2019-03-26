class User < ApplicationRecord
  has_many :select_classrooms
  has_many :classrooms, through: :select_classrooms
end
