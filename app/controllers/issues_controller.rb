class IssuesController < ApplicationController
  def index
    respond_to do |format|
      format.json do
        issues_info = ::IssuesService.new(current_user).all
        render json: issues_info
      end
      format.html
    end
  end
end
