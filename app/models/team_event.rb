class TeamEvent < ApplicationRecord
  belongs_to :classroom
  has_many :team_states, dependent: :destroy
  validates :name, presence: {message: '请填写团队事件名称'}, uniqueness: {message: '该名称已被使用'}
  validates :description, presence: {message: '请填写团队事件描述'}
  validates :code, presence: {message: '请填写团队事件定义代码'}
end
