Rails.application.routes.draw do
  require 'sidekiq/web'

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["SIDEKIQ_WEB_USERNAME"] && password == ENV["SIDEKIQ_WEB_PASSWORD"]
  end if Rails.env.production?

  devise_for :users
  root to: "pages#home"

  resources :cars do
    member do
      post 'favorite'
    end

    collection do
      get :my_cars
      get :pending_approval
      get :search, to: 'cars#index'
      get :filter
      get :confirm_vin
    end
    resources :rentals, only: [:index, :new, :create, :show, :destroy] do
      member do
        patch :approve
        patch :reject
      end
    end
    resources :reviews, only: [:create, :index]
  end

  get 'all_cars', to: 'cars#index', as: 'all_cars'

  resources :favorites, only: [:index, :create, :destroy]
  resources :rentals, only: [:index, :new, :create, :show, :destroy, :edit, :update]
  resource :profile, only: [:show, :edit, :update]
  resources :notifications, only: [:index, :show] do
    member do
      patch :mark_as_read
      patch :approve
      patch :reject
    end
  end
  resources :messages, only: [:index, :new, :create, :show]

  namespace :admin do
    resources :cars, only: [:index] do
      member do
        patch :approve
        patch :reject
      end
    end
  end

  mount ActionCable.server => '/cable'

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
