Rails.application.routes.draw do
  root to: "welcome#index"

  namespace :rider do
    root to: "rides#index"
    resources :rides
  end

  namespace :driver do
    root to: "rides#index"
    resources :rides
  end

  devise_for :users
  resources :locations

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
