class CommentsController < ApplicationController
  def index
    respond_to do |format|
      format.json do
        project_id = params[:project_id]
        blog_id = params[:blog_id]
        comments = comments_service.get_comments project_id, blog_id
        render json: comments
      end
    end
  end

  def create
    respond_to do |format|
      format.json do
        project_id = params[:project_id]
        blog_id = params[:blog_id]
        new_comment = params[:comment]
        comment = comments_service.new_comment project_id, blog_id, new_comment
        render json: comment
      end
    end
  end

  def update
    respond_to do |format|
      format.json do
        project_id = params[:project_id]
        blog_id = params[:blog_id]
        comment_id = params[:id]
        update = params[:update]
        comment = comments_service.update_comment project_id, blog_id, comment_id, update
        render json: comment
      end
    end
  end

  def destroy
    respond_to do |format|
      format.json do
        project_id = params[:project_id]
        blog_id = params[:blog_id]
        comment_id = params[:id]
        res = comments_service.delete_comment project_id, blog_id, comment_id
        render plain: res
      end
    end
  end

  private

  def comments_service
    ::CommentsService.new current_user
  end
end
