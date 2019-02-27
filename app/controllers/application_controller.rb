class ApplicationController < ActionController::Base
  include ::GitlabApi
  include UsersHelper

  before_action :require_login
  skip_before_action :verify_authenticity_token #, unless: csrf_required?

  # rescue_from Exception, with: :render_404
  # rescue_from ActiveRecord::RecordNotFound, with: :render_404
  # rescue_from ActionController::RoutingError, with: :render_404

  # def csrf_required?
  #   !request.format.json?
  # end

  def render_404
    render file: "#{Rails.root}/public/404.html", status: 404
  end

  def require_login
    redirect_to login_url unless logged_in?
  end
end
