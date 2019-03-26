class GroupsService < BaseService
  def new_group(group)
    post 'groups', group
  end

  def get_group(group_id)
    get "groups/#{group_id}"
  end

  def delete_group(group_id)
    delete "groups/#{group_id}"
  end

  def get_projects(group_id)
    get "groups/#{group_id}/projects"
  end

  def add_member(group_id, member)
    post "groups/#{group_id}/members", member
  end

  def get_members(group_id)
    get "groups/#{group_id}/members/all"
  end

  def delete_member(group_id, user_id)
    delete "groups/#{group_id}/members/#{user_id}"
  end
end