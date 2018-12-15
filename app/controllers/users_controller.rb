class UsersController < ApplicationController
  skip_before_action :require_login, only: [:login]

  def login
    access_code = params['code']
    return unless access_code

    access_token = user_auth access_code
    if access_token
      log_in access_token
      redirect_to root_url
    else
      # return 403
      template_path = File.join(Rails.root, 'public/403.html')
      render file: template_path, status: 403, layout: false
    end
  end
end
