# frozen_string_literal: true

class ClassroomsController < ApplicationController
  def index
    @classrooms = []
    user = User.find_by(gitlab_id: current_user)
    Classroom.all.each do |classroom|
      klass = groups_service.get_group(classroom.gitlab_group_id)
      klass['id'] = classroom.id
      @classrooms << klass
    end
  end

  def new
    @errors = []
    @classroom = Classroom.new
  end

  def create
    owner = User.find_by(gitlab_id: current_user.id)
    @classroom = params[:classroom]
    classroom = owner.classrooms.new params.require(:classroom).permit(:name, :path, :description)
    @classroom['visibility'] = 'public'
    @classroom['request_access_enabled'] = true
    unless classroom.valid?
      @errors = get_record_errors classroom
      render 'new'
      return
    end
    group = groups_service.new_group @classroom
    classroom.gitlab_group_id = group['id']
    # 团队项目 subgroup
    team_project_dir = new_team_project_dir(group['id'])
    team_project_group = groups_service.new_group(team_project_dir)
    classroom.team_project_subgroup_id = team_project_group['id']
    # 个人项目 subgroup
    personal_project_dir = new_personal_project_dir(group['id'])
    personal_project_group = groups_service.new_group(personal_project_dir)
    classroom.personal_project_subgroup_id = personal_project_group['id']
    # 结对项目 subgroup
    pair_project_dir = new_pair_project_dir(group['id'])
    pair_project_group = groups_service.new_group(pair_project_dir)
    classroom.pair_project_subgroup_id = pair_project_group['id']
    classroom.save
    classroom.users << owner
    redirect_to classrooms_path
  rescue RestClient::BadRequest => e
    @errors = if classroom.errors.any?
                get_record_errors classroom
              else
                ['名称或地址包含非法字符']
              end
    render 'new'
  end

  def destroy
    @classroom = Classroom.find(params[:id])
    @classroom.destroy
    groups_service.delete_group @classroom.gitlab_group_id
    redirect_to classrooms_path
  end

  def show
    @classroom_record = Classroom.find(params[:id])
    @classroom = groups_service.get_group @classroom_record.gitlab_group_id
    @personal_projects = groups_service.get_projects @classroom_record.personal_project_subgroup_id
    @pair_projects = groups_service.get_projects @classroom_record.pair_project_subgroup_id
    @team_projects = groups_service.get_projects @classroom_record.team_project_subgroup_id
    users = groups_service.get_members @classroom_record.gitlab_group_id
    # 所有 student
    @students = users.find_all do |s|
      !@classroom_record.users.find_by(gitlab_id: s['id'], role: 'student').nil?
    end
    # 所有 teacher
    @teachers = users.find_all do |s|
      !@classroom_record.users.find_by(gitlab_id: s['id'], role: 'teacher').nil?
    end
    @teachers.each do |t|
      t['is_me'] = t['id'] == current_user.id
    end
  end

  private

  def new_team_project_dir(parent_id)
    team_project_dir = {}
    team_project_dir['name'] = '团队项目'
    team_project_dir['path'] = 'team-projects'
    team_project_dir['description'] = '团队项目文件夹，同学们在这里创建自己的团队项目'
    team_project_dir['visibility'] = 'public'
    team_project_dir['request_access_enabled'] = true
    team_project_dir['parent_id'] = parent_id
    team_project_dir
  end

  def new_personal_project_dir(parent_id)
    team_project_dir = {}
    team_project_dir['name'] = '个人项目'
    team_project_dir['path'] = 'personal-projects'
    team_project_dir['description'] = '个人项目文件夹，同学们在这里 fork 个人项目作业'
    team_project_dir['visibility'] = 'public'
    team_project_dir['request_access_enabled'] = true
    team_project_dir['parent_id'] = parent_id
    team_project_dir
  end

  def new_pair_project_dir(parent_id)
    team_project_dir = {}
    team_project_dir['name'] = '结对项目'
    team_project_dir['path'] = 'pair-projects'
    team_project_dir['description'] = '结对项目文件夹，同学们在这里 fork 结对项目作业'
    team_project_dir['visibility'] = 'public'
    team_project_dir['request_access_enabled'] = true
    team_project_dir['parent_id'] = parent_id
    team_project_dir
  end

  def groups_service
    ::GroupsService.new current_user
  end
end
