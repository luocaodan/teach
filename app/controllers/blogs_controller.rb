class BlogsController < ApplicationController
  def index
    respond_to do |format|
      format.json do
        blogs = blogs_service.all search_params
        render json: blogs
      end
      format.html
    end
  end

  private

  def blogs_service
    ::BlogsService.new current_user
  end

  def search_params
    params.permit :type, :scope, :project
  end
end
