class Classroom < ApplicationRecord
  validates :name, uniqueness: {message: ->(obj, data) {'班级名已被占用'}}
  validates :path, uniqueness: { case_sensitive: false,
                                 message: '班级地址已被占用' }
  has_many :select_classrooms
  has_many :users, through: :select_classrooms
end
