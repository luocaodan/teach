class ReportController < ApplicationController
  skip_before_action :require_login, only: [:index]
  before_action :authenticate

  def index
    respond_to do |format|
      format.json do
        add_student_test_record params.permit(
          :project, :score, :unittest
        )
        render json: {status: 'success'}
      end
    end
  end

  private

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      ActiveSupport::SecurityUtils.secure_compare(token, Constant::ReportToken)
    end
  end

  def add_student_test_record(params)
    project_id = params[:project]
    project = get_project project_id
    return unless project['forked_from_project']
    # 查找项目所属班级
    forked_id = project['forked_from_project']['id']
    auto_test_project = AutoTestProject.find_by(gitlab_id: forked_id)
    return unless auto_test_project
    classroom = auto_test_project.classroom
    owner_id = project['owner']['id']
    # 是否为学生
    student = classroom.users.find_by(gitlab_id: owner_id, role: 'student')
    return unless student

    exist_records = auto_test_project.student_test_records
    record = exist_records.find_by user_id: student.id, project_id: project_id
    unless record
      record = exist_records.new user_id: student.id, project_id: project_id
    end
    record.score = params[:score]
    record.unittest = params[:unittest]
    record.save
  end

  private

  def get_project(project_id)
    admin_api_get "projects/#{project_id}"
  end
end
