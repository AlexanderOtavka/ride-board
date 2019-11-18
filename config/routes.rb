Rails.application.routes.draw do
  root to: "rides#index"

  resources :rides
  resources :locations
  devise_for :users, path: "me"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
