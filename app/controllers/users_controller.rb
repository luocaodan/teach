class UsersController < ApplicationController
  def new
    classroom = Classroom.find params[:classroom_id]
    # 添加一个学生到班级
    @students = users_service.all.find_all{ |u| Tools.is_student(u['username'])}
    @students.each do |s|
      if classroom.users.find_by(gitlab_id: s['id'])
        s['added'] = true
      else
        s['added'] = false
      end
    end
  end

  def destroy
    classroom = Classroom.find(params[:classroom_id])
    gitlab_user_id = params[:id]
    user = User.find_by(gitlab_id: gitlab_user_id)
    sc = SelectClassroom.find_by(user_id: user.id, classroom_id: classroom.id)
    sc.destroy
    groups_service.delete_member classroom.gitlab_group_id, gitlab_user_id
    render json: {statue: 'success'}
  end

  def create
    @classroom = Classroom.find(params[:classroom_id])
    gitlab_user_id = params[:user]
    user = User.find_by(gitlab_id: gitlab_user_id)
    user ||= User.create gitlab_id: gitlab_user_id, role: 'student'
    SelectClassroom.create(user_id: user.id, classroom_id: @classroom.id)
    # 添加学生为 group 成员
    reporter = 20
    maintainer = 40
    member = {}
    member['user_id'] = gitlab_user_id
    member['access_level'] = reporter
    groups_service.add_member @classroom.gitlab_group_id, member
    # 重新添加到 团队项目 subgroup 团队项目group可以创建项目
    member['access_level'] = maintainer
    groups_service.add_member @classroom.team_project_subgroup_id, member
    render json: {statue: 'success'}
  end

  private

  def users_service
    ::UsersService.new current_user
  end

  def groups_service
    ::GroupsService.new current_user
  end
end
