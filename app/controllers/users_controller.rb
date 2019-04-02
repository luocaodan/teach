class UsersController < ApplicationController
  def new
    classroom = Classroom.find params[:classroom_id]
    @type = params[:type]
    render_404 unless @type
    @page = params[:page]
    @page ||= 1
    # type: student 添加一个学生到班级
    # type: teacher 添加一个老师或助教
    @students, gitlab_headers = users_service.all page: @page
    @page_count = gitlab_headers[:x_total_pages].to_i
    render_404 if @page > @page_count
    @students.each do |s|
      s['added'] = !classroom.users.find_by(gitlab_id: s['id']).nil?
    end
  end

  def destroy
    classroom = Classroom.find(params[:classroom_id])
    gitlab_user_id = params[:id]
    user = User.find_by(gitlab_id: gitlab_user_id)
    sc = SelectClassroom.find_by(user_id: user.id, classroom_id: classroom.id)
    sc.destroy
    groups_service.delete_member classroom.gitlab_group_id, gitlab_user_id
    render json: {status: 'success'}
  end

  def create
    type = params[:type]
    @classroom = Classroom.find(params[:classroom_id])
    gitlab_user_id = params[:user_id]
    gitlab_username = params[:username]
    user = User.find_by(gitlab_id: gitlab_user_id)
    user ||= User.create gitlab_id: gitlab_user_id, role: type, username: gitlab_username
    SelectClassroom.create(user_id: user.id, classroom_id: @classroom.id)
    # 添加学生为 group 成员
    reporter = 20
    maintainer = 40
    # 老师或助教 owner 权限
    owner = 50
    member = {}
    member['user_id'] = gitlab_user_id
    member['access_level'] = type == 'teacher' ? owner : reporter
    groups_service.add_member @classroom.gitlab_group_id, member
    # 学生重新添加到 团队项目 subgroup 团队项目group可以创建项目
    # if type == 'student'
    #   member['access_level'] = maintainer
    #   groups_service.add_member @classroom.team_project_subgroup_id, member
    # end
    render json: {status: 'success'}
  end

  private

  def users_service
    ::UsersService.new current_user
  end

  def groups_service
    ::GroupsService.new current_user
  end
end
