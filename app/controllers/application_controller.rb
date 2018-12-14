class ApplicationController < ActionController::Base
  include ::GitlabApi
  skip_before_action :verify_authenticity_token #, unless: csrf_required?

  # def csrf_required?
  #   !request.format.json?
  # end
end
