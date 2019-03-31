class AutoTestProject < ApplicationRecord
  has_many :student_test_records, dependent: :destroy
  belongs_to :classroom
end
