class PagesController < ApplicationController
  def main
    redirect_to login_url unless logged_in?
    user_type = session[:type]
    if user_type == 'student'
      redirect_to issues_url
    else
      redirect_to classrooms_url
    end
  end
end
