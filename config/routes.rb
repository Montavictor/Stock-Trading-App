Rails.application.routes.draw do
  get "pages/index"
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  resources :pages

  namespace :admin do
    root to: "dashboard#index"
  # transactions of ALL users  
    get "pending", controller: "users", action: :pending
    resources :transactions, only: [:index, :show]
    resources :users do
      member do
        patch :approve
      end
    end
  end
  resources :stocks
  resources :transactions
  get '/input_quantity' => 'transactions#input_quantity'
  get '/search' => 'transactions#search'

  devise_scope :user do
    get 'users/sign_out' => "devise/sessions#destroy"
  end
  root "pages#index"
  match "*unmatched", to: proc { [404, {}, [File.read(Rails.root.join("public/404.html"))]] }, via: :all

end
