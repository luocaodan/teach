class ApplicationController < ActionController::Base
  include ::GitlabApi
  include UsersHelper

  before_action :require_login
  skip_before_action :verify_authenticity_token #, unless: csrf_required?

  # def csrf_required?
  #   !request.format.json?
  # end

  def require_login
    redirect_to login_url unless logged_in?
  end
end
