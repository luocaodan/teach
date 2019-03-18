class ReportController < ApplicationController
  skip_before_action :require_login, only: [:index]
  before_action :authenticate

  def index
    respond_to do |format|
      format.json do
        if params[:start]
          add_auto_test_project params[:project], params[:forked]
        else
          add_student_test_record params.permit(
            :project, :student, :score, :unittest
          )
        end
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

  def add_auto_test_project(project_id, is_forked)
    project = get_project project_id
    if !project['forked_from_project'] && !is_forked
      return nil
    end
    forked_id = project_id
    unless is_forked
      forked_id = project['forked_from_project']['id']
      project = project['forked_from_project']
    end

    unless AutoTestProject.find_by(id: forked_id)
      AutoTestProject.create(
        id: forked_id,
        name: project['name_with_namespace'],
        description: project['description']
      )
    end
  end

  def add_student_test_record(params)
    project_id = params[:project]
    project = get_project project_id
    forked_id = project['forked_from_project']['id']
    exist_records = AutoTestProject.find(forked_id).student_test_records
    student = params[:student]
    record = exist_records.find_by student: student, project_id: project_id
    unless record
      record = exist_records.new student: student, project_id: project_id
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
