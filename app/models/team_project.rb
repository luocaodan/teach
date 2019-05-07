class TeamProject < ApplicationRecord
  belongs_to :classroom
  attr_accessor :name, :path, :description, :initialize_with_readme
  has_many :contribution_commits, dependent: :destroy
  has_many :contribution_issues, dependent: :destroy
  has_many :team_states, dependent: :destroy
end
