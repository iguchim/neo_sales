Rails.application.routes.draw do
  resources :reference_users
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'sessions/new'

  #root 'static_pages#home' # => root_path
  #root 'requests#index'
  root 'notices#index'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  get '/auth_req', to: 'requests#auth'
  get 'auth_rep', to: 'reports#auth'

  get '/req_state', to: 'requests#state'
  get '/rep_state', to: 'reports#state'

  get 'pdf_format' => 'pdf_formats#show'

  get '/daily_rep_state', to: 'daily_reports#state'
  get '/daily_auth_rep', to: 'daily_reports#auth'

  get '/daily_req_to', to: 'daily_reports#req_to'
  get '/daily_rep_from', to: 'daily_reports#rep_from'
  
  get '/chart', to: 'daily_reports#chart'

  get '/objective_rep_state', to: 'objectives#state'
  get '/objective_auth_rep', to: 'objectives#auth'

  get '/objective_req_to', to: 'objectives#req_to'
  get '/objective_rep_from', to: 'objectives#rep_from'

  get '/objective_detail_rep_state', to: 'objective_details#state'
  get '/objective_detail_auth_rep', to: 'objective_details#auth'

  get '/objective_detail_req_to', to: 'objective_details#req_to'
  get '/objective_detail_rep_from', to: 'objective_details#rep_from'


  #get '/line_chart', to: 'daily_reports#line_chart'
  
  # resources :users do
  #   member do
  #     # /users/:id/ ...
  #     get :following, :followers
  #     # GET /users/1/following => following action
  #     # GET /users/1/followers => followers action
  #   end
  # end

  resources :users do
    resources :requests
  end

  resources :requests do
    resources :reports
  end

  resources :requests do
    resources :request_items
  end

  resources :reports do
    resources :report_items
  end

  resources :orders do
    resources :requests
  end

  resources :events

  get '/schedules', to: 'schedules#index'

  get '/seluser', to: 'events#seluser'

  resources :daily_reports do
    resources :daily_report_details
  end

  resources :daily_report_details

  resources :objectives do
    resources :objective_details
  end

  resources :notices do
    resources :notice_comments
  end
  
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
end
