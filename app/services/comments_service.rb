class CommentsService < BaseService
  def get_comments(project_id, blog_id)
    comments = get "projects/#{project_id}/snippets/#{blog_id}/notes"
    simplify comments
  end

  private

  def simplify(comments)
    comments.each do |comment|
      comment.delete 'attachment'
      comment.delete 'noteable_id'
      comment.delete 'noteable_iid'
      comment.delete 'noteable_type'
      comment.delete 'resolvable'
      comment.delete 'system'
      comment.delete 'type'
      comment['can_edit'] = comment['author']['id'] == user_id
    end
  end
end