class Blog < ApplicationRecord
  belongs_to :classroom
  belongs_to :user

  validates :gitlab_id, presence: true, uniqueness: true
  validates :project_id, presence: true
  validates :blog_type, presence: true
end
