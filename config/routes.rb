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

  resources :issues do
    collection do
      # 全量 issues
      get 'all', to: 'issues#all_issues', constraints: ->(req) {req.format == :json}
    end
  end

  resources :sprints

  resources :projects, only: [], param: :project_id do
    member do
      # project board
      get 'kanban', to: 'boards#index'
      # file upload
      post 'uploads', to: 'uploads#index'

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
        post 'trigger', to: 'auto_test_projects#trigger'
      end
    end

    resources :team_projects, only: %i[show new create] do
      resources :blogs do
        member do
          get 'raw', to: 'blogs#show_raw'
        end
      end
      get 'insight', to: 'insight#show'
    end

    resources :blogs do
      member do
        get 'raw', to: 'blogs#show_raw'
      end
    end

    member do
      get 'join', to: 'classrooms#join'
      get 'exit', to: 'classrooms#exit'
    end
  end

  resources :blogs, only: [] do
    resources :comments, only: %i[index create update destroy], constraints: ->(req) {req.format == :json}
  end
end
