class Issue < ApplicationRecord
  validates :project_id, presence: true
end
