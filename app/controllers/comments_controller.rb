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

  private

  def comments_service
    ::CommentsService.new current_user
  end
end
