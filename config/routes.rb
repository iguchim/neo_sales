Rails.application.routes.draw do
  resources :reference_users
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'sessions/new'

  #root 'static_pages#home' # => root_path
  root 'requests#index'
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

  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
end
