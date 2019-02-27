module CommentsHelper
  def comments_data
    project_id = params[:project_id]
    blog_id = params[:id]
    {
      endpoint: blog_comments_url(project_id, blog_id, format: :json)
    }
  end
end
