Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  get "up" => "rails/health#show", as: :rails_health_check

  resources :cars, only: [:index, :show] do
    resources :rentals, only: [:index]
  end
end
