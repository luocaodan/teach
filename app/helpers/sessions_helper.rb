module SessionsHelper
  def gitlab_auth_url(user_type)
    # user_type: student | teacher
    # gitlab auth
    # https://docs.gitlab.com/ce/api/oauth2.html#resource-owner-password-credentials
    <<~EOF.gsub("\n", "")
      #{gitlab_host}/oauth/authorize?
      client_id=#{app_id}&
      redirect_uri=#{redirect_uri}&
      response_type=code&
      state=#{user_type}
    EOF
  end

  # log in user
  def log_in(token)
    session[:user_token] = token
    user_info = user_api_get 'user', token
    session[:user_id] = user_info['id']
    session[:username] = user_info['username']
    session[:name] = user_info['name']
    session[:avatar_url] = user_info['avatar_url']
    session[:web_url] = user_info['web_url']
  end

  def logged_in?
    session.key? :user_token
  end

  def current_user
    @current_user ||= Session.new session[:user_id], session[:user_token], session[:username]
    @current_user.name = session[:name]
    @current_user.avatar_url = session[:avatar_url]
    @current_user.web_url = session[:web_url]
    @current_user.type = session[:type]
    @current_user
  end

  def student?
    session[:type] == 'student'
  end

  def teacher?
    session[:type] == 'teacher'
  end
end
