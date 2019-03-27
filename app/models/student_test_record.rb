class StudentTestRecord < ApplicationRecord
  belongs_to :auto_test_project
  belongs_to :user
end
