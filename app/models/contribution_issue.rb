class ContributionIssue < ApplicationRecord
  belongs_to :issue
  belongs_to :team_project
  belongs_to :user
end
