remove_file 'config/routes.rb'
create_file 'config/routes.rb', <<~RUBY
  Rails.application.routes.draw do
    # Root for Unauthenticated & Authenticated Users
    root "dashboard#index"

    # API Endpoint (optional)
    namespace :api do
      namespace :v1 do
        post "/:id", to: "example#index"
      end
    end

    # Account
    get "/account", to: "account#index", as: :account

    # Registration
    post "register", to: "registration#create", as: :registration
    get "register", to: "registration#new", as: :new_registration

    # Login
    get "login", to: "sessions#new", as: :new_session
    post "login", to: "sessions#create", as: :session
    delete "login", to: "sessions#destroy", as: :destroy_session

    # Passwords
    resources :passwords, param: :token

    # Health Check
    get "up" => "rails/health#show", as: :rails_health_check
  end
RUBY
