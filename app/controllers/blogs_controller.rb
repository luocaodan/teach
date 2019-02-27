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

  def update
    respond_to do |format|
      format.json do
        project_id = params[:project_id]
        blog_id = params[:id]
        update = params[:update]
        blog = blogs_service.update_blog project_id, blog_id, update
        render json: blog
      end
    end
  end

  def destroy
    respond_to do |format|
      format.json do
        project_id = params[:project_id]
        blog_id = params[:id]
        res = blogs_service.delete_blog project_id, blog_id
        render plain: res
      end
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
