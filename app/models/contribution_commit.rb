class ContributionCommit < ApplicationRecord
  belongs_to :team_project
  belongs_to :user

  validates :gitlab_id, presence: true, uniqueness: true
end
