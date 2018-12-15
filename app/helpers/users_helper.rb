module UsersHelper
  def gitlab_auth_url
    # gitlab auth
    # https://docs.gitlab.com/ce/api/oauth2.html#resource-owner-password-credentials
    <<~EOF.gsub("\n", "")
      #{gitlab_host}/oauth/authorize?
      client_id=#{app_id}&
      redirect_uri=#{redirect_uri}&
      response_type=code
    EOF
  end

  # log in user
  def log_in(token)
    session[:user_token] = token
    user_info = user_api_get 'user', token
    session[:user_id] = user_info['id']
  end

  def logged_in?
    session.key? :user_token
  end

  def current_user
    @current_user ||= User.new session[:user_id], session[:user_token]
  end
end
