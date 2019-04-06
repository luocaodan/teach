class BlogsController < ApplicationController
  before_action :check_classroom

  def index
    respond_to do |format|
      format.json do
        classroom = Classroom.find(params[:classroom_id])
        type_query = if search_params[:type] == 'all'
                       %w[blog daily_scrum]
                     else
                       search_params[:type]
                     end
        if search_params[:scope] == 'my'
          user = User.find_by(gitlab_id: current_user.id)
          blog_records = classroom.blogs.where(user_id: user.id, blog_type: type_query)
        else
          blog_records = classroom.blogs.where(blog_type: type_query)
        end
        blogs = []
        blog_records.each do |br|
          blog = blogs_service.get_blog br.project_id, br.gitlab_id
          blog['id'] = br.id
          blog['gitlab_id'] = br.gitlab_id
          project = admin_api_get "projects/#{br.project_id}"
          blog['project_name'] = project['name_with_namespace']
          blogs << blog
        end
        render json: blogs
      end
      format.html
    end
  end

  def new

  end

  def show
    blog = Blog.find(params[:id])
    render_404 unless blog.classroom_id == params[:classroom_id].to_i
  end

  def show_raw
    classroom = Classroom.find(params[:classroom_id])
    blog = classroom.blogs.find(params[:id])
    code = blogs_service.get_blog_raw_code blog.project_id, blog.gitlab_id
    render plain: code
  end

  def create
    classroom = Classroom.find(params[:classroom_id])
    new_blog = params[:blog]
    type = 'blog'
    if new_blog['file_name'] == 'daily_scrum.md'
      type = 'daily_scrum'
    end
    blog_record = classroom.blogs.new project_id: new_blog['project_id'], blog_type: type
    blog = blogs_service.new_blog new_blog
    blog_record.gitlab_id = blog['id']
    user = User.find_by(gitlab_id: current_user.id)
    blog_record.user_id = user.id
    blog_record.save
    redirect_to classroom_blogs_path
  end

  def update
    respond_to do |format|
      format.json do
        classroom = Classroom.find(params[:classroom_id])
        blog_record = classroom.blogs.find(params[:id])
        update = params[:update]
        blog = blogs_service.update_blog blog_record.project_id, blog_record.gitlab_id, update
        render json: blog
      end
    end
  end

  def destroy
    respond_to do |format|
      format.json do
        classroom = Classroom.find(params[:classroom_id])
        blog = classroom.blogs.find(params[:id])
        res = blogs_service.delete_blog blog.project_id, blog.gitlab_id
        blog.destroy
        render plain: res
      end
    end
  end

  private

  def blogs_service
    ::BlogsService.new current_user
  end

  def search_params
    params.permit :type, :scope
  end

  def check_classroom
    classroom = Classroom.find(params[:classroom_id])
    user = User.find_by(gitlab_id: current_user.id)
    unless classroom.users.include? user
      render_403
      return
    end
  end
end
