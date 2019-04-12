class ContributionCommit < ApplicationRecord
  belongs_to :team_project
  belongs_to :user
end
