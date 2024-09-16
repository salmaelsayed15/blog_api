Rails.application.routes.draw do
  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # User authentication routes
  # post "register", to: "users#create"  #  Only create the user without handling authentication
  post "register", to: "registrations#create" # Handle both user creation and token generation upon user registration
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # Defines the root path route ("/")
  # root "posts#index"

  resources :posts do
    resources :comments, only: [ :index, :create, :update, :destroy ]
    # patch "update_tags", on: :member
  end

  # get "/posts/:id", to: "posts#show"
end
