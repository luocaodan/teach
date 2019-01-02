Rails.application.routes.draw do
  # system hook for add system-wide webhook
  post '/system', to: 'system#index'

  # oauth application
  get '/login', to: 'users#login'
  get '/oauth/callback', to: 'users#login'

  resources :issues

  # file upload
  post '/projects/:project_id/uploads', to: 'uploads#index'

  # issues as root
  root 'issues#index'
end
