Rails.application.routes.draw do
  root to: "welcome#index"

  namespace :passenger do
    root to: "rides#index"
    resources :rides
    post   "/rides/:id/join", to: "rides#join",  as: :join_ride
    delete "/rides/:id/join", to: "rides#leave"
  end

  namespace :driver do
    root to: "rides#index"
    resources :rides
    post   "/rides/:id/join", to: "rides#join",  as: :join_ride
    delete "/rides/:id/join", to: "rides#leave"
  end

  devise_for :users
  resources :locations

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
