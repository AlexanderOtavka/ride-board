Rails.application.routes.draw do
  resources :locations
  devise_for :users
  root to: "rides#index"

  resources :rides
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
