Rails.application.routes.draw do
  get 'users/new'
  get 'users/destroy'
  root 'pages#main'
  # system hook for add system-wide webhook
  post '/system', to: 'system#index'

  # webhook for every project
  post '/webhook', to: 'webhook#index'

  # report interface for receive auto test result
  post '/report', to: 'report#index'

  # oauth application
  get '/login', to: 'sessions#login'
  get '/oauth/callback', to: 'sessions#login'

  resources :issues

  resources :sprints

  resources :blogs, only: %i[index new create]

  resources :projects, only: [], param: :project_id do
    member do
      # project board
      get 'kanban', to: 'boards#index'
      # file upload
      post 'uploads', to: 'uploads#index'
      resources :blogs, only: %i[show create update destroy] do
        member do
          get 'raw', to: 'blogs#show_raw'
        end

        resources :comments, only: %i[index create update destroy], constraints: ->(req) {req.format == :json}
      end

      get 'web_url', to: 'uploads#upload_url'
    end
  end

  resources :milestones, only: [], param: :milestone_id do
    member do
      # milestone board
      get 'kanban', to: 'boards#index'
      # burndown chart
      get 'burndown', to: 'burndown#index'
    end
  end

  # teachers
  resources :classrooms do
    resources :users, only: %i[new create destroy]
    resources :auto_test_projects, only: %i[show] do
      member do
        post 'feedback', to: 'auto_test_projects#feedback'
      end
    end
    resources :team_projects, only: %i[show new create]
    member do
      get 'join', to: 'classrooms#join'
      get 'exit', to: 'classrooms#exit'
    end
  end
end
