class ContributionIssue < ApplicationRecord
  has_one :issue
  belongs_to :team_project
  belongs_to :user
end
