class BlogsService < BaseService
  # def all(params)
  #   type all | blog | daily_scrum
  #   scope all | my
  #   project all | :project_id
  # snippets = []
  # if params[:project] == 'all'
  #   snippets = get 'snippets/public'
  #   a = snippets
  # else
  #   project_id = params[:project]
  #   snippets = get "projects/#{project_id}/snippets"
  # end
  # if params[:scope] == 'my'
  #   snippets = snippets.find_all {|s| s['author']['id'] == user_id}
  # end
  # snippets = if params[:type] == 'blog'
  #              get_blogs snippets
  #            elsif params[:type] == 'daily_scrum'
  #              get_daily_scrums snippets
  #            else
  #              get_blogs(snippets).concat(get_daily_scrums(snippets))
  #            end
  # end

  def new_blog(blog)
    project_id = blog.delete 'project_id'
    blog['visibility'] = 'public'
    post "projects/#{project_id}/snippets", blog
  end

  def get_blog(project_id, blog_id)
    blog = get "projects/#{project_id}/snippets/#{blog_id}"
    simplify blog
    get_comments_count blog
    blog
  end

  def get_blog_raw_code(project_id, blog_id)
    plain_get "projects/#{project_id}/snippets/#{blog_id}/raw"
  end

  def update_blog(project_id, blog_id, update)
    blog = put "projects/#{project_id}/snippets/#{blog_id}", update
    simplify blog
    get_comments_count blog
    blog
  end

  def delete_blog(project_id, blog_id)
    delete "projects/#{project_id}/snippets/#{blog_id}"
  end

  private

  def simplify(snippet)
    snippet.delete 'description'
    snippet.delete 'visibility'
    snippet.delete 'web_url'
    snippet.delete 'raw_url'
    snippet['type'] = if snippet['file_name'] == 'blog.md'
                        'Blog'
                      else
                        'Daily Scrum'
                      end
    snippet.delete 'file_name'
    snippet['can_edit'] = snippet['author']['id'] == user_id
  end

  def get_comments_count(snippet)
    comments = get "projects/#{snippet['project_id']}/snippets/#{snippet['id']}/discussions"
    snippet['comments_count'] = comments.length
  end
end