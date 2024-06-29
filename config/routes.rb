Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  get "up" => "rails/health#show", as: :rails_health_check

  resources :cars do
    collection do
      get :my_cars
      get :pending_approval
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

  # Mount ActionCable server
  mount ActionCable.server => '/cable'
end
