class Classroom < ApplicationRecord
  attr_accessor :name, :path, :description, :personal, :pair, :team
  has_many :select_classrooms, dependent: :destroy
  has_many :users, through: :select_classrooms
  has_many :auto_test_projects, dependent: :destroy
  has_many :team_projects, dependent: :destroy
  has_many :blogs, dependent: :destroy
  has_many :team_events, dependent: :destroy

  validates :gitlab_group_id, presence: true, uniqueness: true

  def initialize(*args)
    super
    @personal = true
    @pair = true
    @team = true
  end

  def to_json
    {
      name: @name,
      path: @path,
      description: @desription,
      personal: @personal,
      pair: @pair,
      team: @team
    }.to_json
  end
end
