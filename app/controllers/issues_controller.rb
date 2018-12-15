class IssuesController < ApplicationController
  def index
    ::IssuesService.new(current_user).all
  end
end
