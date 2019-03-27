# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:login]
  before_action :login_redirect, only: [:login]

  def login
    access_code = params['code']
    user_type = params['state']
    return unless access_code

    access_token = user_auth access_code
    if access_token
      session[:type] = user_type
      log_in access_token
      unless create_user(session[:user_id], session[:type])
        render_403
        return
      end
      redirect_to root_url
    else
      # return 403
      render_403
    end
  end

  private

  def login_redirect
    redirect_to root_url if logged_in?
  end
  
  def render_403
    template_path = File.join(Rails.root, 'public/403.html')
    render file: template_path, status: 403, layout: false
  end
  
  def create_user()
    gitlab_user_id = session[:user_id]
    type = session[:type]
    username = session[:username]
    user = User.find_by(gitlab_id: gitlab_user_id)
    return false if user && user.role != type
    User.create(gitlab_id: gitlab_user_id, role: type, username: username) unless user
    true
  end
end
