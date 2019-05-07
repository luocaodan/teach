class TeamState < ApplicationRecord
  belongs_to :team_event
  belongs_to :team_project
end
