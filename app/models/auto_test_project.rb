class AutoTestProject < ApplicationRecord
  has_many :student_test_records
  belongs_to :classroom
end
