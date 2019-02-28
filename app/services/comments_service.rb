class CommentsService < BaseService
  def get_comments(project_id, blog_id)
    comments = get "projects/#{project_id}/snippets/#{blog_id}/notes", sort: 'asc'
    comments.each(&method(:simplify))
  end

  def new_comment(project_id, blog_id, new_comment)
    comment = post "projects/#{project_id}/snippets/#{blog_id}/notes", new_comment
    simplify comment
  end

  def update_comment(project_id, blog_id, comment_id, update)
    comment = put "projects/#{project_id}/snippets/#{blog_id}/notes/#{comment_id}", update
    simplify comment
  end

  def delete_comment(project_id, blog_id, comment_id)
    delete "projects/#{project_id}/snippets/#{blog_id}/notes/#{comment_id}"
  end

  private

  def simplify(comment)
    comment.delete 'attachment'
    comment.delete 'noteable_id'
    comment.delete 'noteable_iid'
    comment.delete 'noteable_type'
    comment.delete 'resolvable'
    comment.delete 'system'
    comment.delete 'type'
    comment['can_edit'] = comment['author']['id'] == user_id
    comment
  end
end