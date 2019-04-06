require 'json'

module BlogsHelper
  def blogs_data
    {
      endpoint: classroom_blogs_url(format: :json),
    }
  end

  def new_blog_data
    blogs_data.merge!(type: params[:type])
  end

  def current_blog
    blog_record = Blog.find(params[:id])
    project_id = blog_record.project_id
    blog = blogs_service.get_blog project_id, blog_record.gitlab_id
    project = admin_api_get "projects/#{project_id}"
    blog['id'] = blog_record.id
    blog['project_id'] = project_id.to_i
    blog['project_url'] = project['web_url']
    blog.to_json
  end

  def blogs_service
    ::BlogsService.new current_user
  end
end
