Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'home#index'
  namespace :api do
    namespace :v1 do
      resources :emails, only: :create
    end
  end

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
