class BlogsService < BaseService
  def all(params)
    # type all | blog | daily_scrum
    # scope all | my
    # project all | :project_id
    snippets = []
    if params[:project] == 'all'
      snippets = get 'snippets/public'
      a = snippets
    else
      project_id = params[:project]
      snippets = get "projects/#{project_id}/snippets"
    end
    if params[:scope] == 'my'
      snippets = snippets.find_all {|s| s['author']['id'] == user_id}
    end
    snippets = if params[:type] == 'blog'
                 get_blogs snippets
               elsif params[:type] == 'daily_scrum'
                 get_daily_scrums snippets
               else
                 get_blogs(snippets).concat(get_daily_scrums(snippets))
               end
    simplify snippets
    get_comments_count snippets
  end

  def new_blog(blog)
    project_id = blog.delete 'project_id'
    blog['visibility'] = 'public'
    post "projects/#{project_id}/snippets", blog
  end

  def get_blog(project_id, blog_id)
    get "projects/#{project_id}/snippets/#{blog_id}"
  end

  def get_blog_raw_code(project_id, blog_id)
    plain_get "projects/#{project_id}/snippets/#{blog_id}/raw"
  end

  def update_blog(project_id, blog_id, update)
    blog = put "projects/#{project_id}/snippets/#{blog_id}", update
    blog.delete 'file_name'
    blog.delete 'description'
    blog.delete 'visibility'
    blog.delete 'web_url'
    blog['can_edit'] = blog['author']['id'] == user_id
    blog
  end

  def delete_blog(project_id, blog_id)
    delete "projects/#{project_id}/snippets/#{blog_id}"
  end

  private

  def get_blogs(snippets)
    snippets.find_all {|s| s['file_name'] == 'blog.md'}
  end

  def get_daily_scrums(snippets)
    snippets.find_all {|s| s['file_name'] == 'daily_scrum.md'}
  end

  def simplify(snippets)
    snippets.each do |snippet|
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
    end
  end

  def get_comments_count(snippets)
    snippets.each do |snippet|
      comments = get "projects/#{snippet['project_id']}/snippets/#{snippet['id']}/discussions"
      snippet['comments_count'] = comments.length
    end
  end
end