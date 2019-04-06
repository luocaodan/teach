class CommentsController < ApplicationController
  def index
    respond_to do |format|
      format.json do
        comments = comments_service.get_comments current_blog.project_id, current_blog.gitlab_id
        render json: comments
      end
    end
  end

  def create
    respond_to do |format|
      format.json do
        new_comment = params[:comment]
        comment = comments_service.new_comment current_blog.project_id, current_blog.gitlab_id, new_comment
        render json: comment
      end
    end
  end

  def update
    respond_to do |format|
      format.json do
        comment_id = params[:id]
        update = params[:update]
        comment = comments_service.update_comment current_blog.project_id, current_blog.gitlab_id, comment_id, update
        render json: comment
      end
    end
  end

  def destroy
    respond_to do |format|
      format.json do
        comment_id = params[:id]
        res = comments_service.delete_comment current_blog.project_id, current_blog.gitlab_id, comment_id
        render plain: res
      end
    end
  end

  private

  def comments_service
    ::CommentsService.new current_user
  end

  def current_blog
    Blog.find(params[:blog_id])
  end
end
