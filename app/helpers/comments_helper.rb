module CommentsHelper
  def comments_data
    {
      endpoint: blog_comments_path(blog_id: params[:id], format: :json)
    }
  end
end
