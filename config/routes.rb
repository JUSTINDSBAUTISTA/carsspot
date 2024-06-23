# config/routes.rb
Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  get "up" => "rails/health#show", as: :rails_health_check

  resources :cars do
    member do
      patch :approve
      patch :reject
    end
    collection do
      get :my_cars
    end
    resources :rentals, only: [:index, :new, :create, :show, :destroy]
  end

  get 'all_cars', to: 'cars#index', as: 'all_cars'

  resources :favorites, only: [:index, :create, :destroy]
  resources :rentals, only: [:index, :new, :create, :show, :destroy]
  resource :profile, only: [:show, :edit, :update]
  resources :notifications, only: [:index, :show] do
    member do
      patch :mark_as_read
      patch :approve
      patch :reject
    end
  end
  resources :messages, only: [:index, :new, :create, :show]
end
