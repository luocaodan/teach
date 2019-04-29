class TeamEvent < ApplicationRecord
  belongs_to :classroom
  validates :name, presence: {message: '请填写团队事件名称'}, uniqueness: {message: 'hah'}
  validates :description, presence: {message: '请填写团队事件描述'}
  validates :code, presence: {message: '请填写团队事件定义代码'}
end
