Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # system hook for add system-wide webhook
  post '/system', to: 'system#index'
  get '/system', to: 'system#index'
end
