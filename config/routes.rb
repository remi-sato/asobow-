Rails.application.routes.draw do
  get "notifications/index"
  get "community_notice/new"
  get "community_notice/create"
  get "community_notice/show"
  get "tags/index"
  get "tags/show"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  root "homes#top"
  get "about" => "homes#about"

  resources :users, except: [ :index ]
  get "mypage" => "users#mypage"

  resources :posts do
    resource :favorite, only: [ :create, :destroy ]
    resources :comments, only: [ :create, :destroy ]
  end

  resources :dogs, except: [ :index, :show ]
  resources :tags, only: [ :index, :show ]
  resources :communities do
    resources :community_users, only: [ :new, :create, :destroy ]
    resource :community_notice, only: [ :new, :create, :show ]
    member do
      get :requests
   end
  end

  resources :community_users, only: [] do
    member do
      patch :approve
      patch :reject
      delete :remove
    end
  end

  resources :notifications, only: [ :index ]

  get "/login" => "sessions#new"
  post "/login" => "sessions#create"
  delete "/logout" => "sessions#destroy"

  get "/search" => "searches#search"

  namespace :admin do
    root "homes#index"

    get "login" => "sessions#new"
    post "login" => "sessions#create"
    delete "logout" => "sessions#destroy"

    resources :users, only: [ :index, :show ] do
      member do
        patch :withdraw
        patch :reactive
      end
    end

    resources :posts, only: [ :index, :show, :destroy ] do
      resources :comments, only: [ :destroy ]
    end
    resources :communities, only: [ :index, :show, :destroy ]
  end
end
