module BlogsHelper
  def blogs_data
    {
      endpoint: blogs_url(format: :json),
    }
  end

  def new_blog_data
    blogs_data.merge!(type: params[:type])
  end
end
