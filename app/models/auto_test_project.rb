class AutoTestProject < ApplicationRecord
  has_many :student_test_records, dependent: :destroy
  belongs_to :classroom

  validates :gitlab_id, presence: true, uniqueness: true
end
