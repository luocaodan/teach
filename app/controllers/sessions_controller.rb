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
      redirect_to root_url
    else
      # return 403
      template_path = File.join(Rails.root, 'public/403.html')
      render file: template_path, status: 403, layout: false
    end
  end

  private

  def login_redirect
    redirect_to root_url if logged_in?
  end
end
