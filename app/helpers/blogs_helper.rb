module BlogsHelper
  def blogs_data
    {
      endpoint: blogs_url(format: :json),
    }
  end

  def blogs_service
    ::BlogsService.new(current_user)
  end
end
