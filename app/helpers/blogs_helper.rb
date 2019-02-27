require 'json'

module BlogsHelper
  def blogs_data
    {
      endpoint: blogs_url(format: :json),
    }
  end

  def new_blog_data
    blogs_data.merge!(type: params[:type])
  end

  def current_blog
    project_id = params[:project_id]
    blog_id = params[:id]
    blog = blogs_service.get_blog project_id, blog_id
    blog.delete 'file_name'
    blog.delete 'description'
    blog.delete 'visibility'
    blog.delete 'web_url'
    blog['can_edit'] = blog['author']['id'] == current_user.id
    blog.to_json
  end

  def blogs_service
    ::BlogsService.new current_user
  end
end
