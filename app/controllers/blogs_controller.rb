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

  def new

  end

  def show

  end

  def show_raw
    project_id = params[:project_id]
    blog_id = params[:blog_id]
    code = blogs_service.get_blog_raw_code project_id, blog_id
    render plain: code
  end

  def create
    new_blog = params[:blog]
    blog = blogs_service.new_blog new_blog
    render json: blog
  end

  private

  def blogs_service
    ::BlogsService.new current_user
  end

  def search_params
    params.permit :type, :scope, :project
  end
end
