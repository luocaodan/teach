class TeamProject < ApplicationRecord
  belongs_to :classroom
  attr_accessor :name, :path, :description, :initialize_with_readme
end
