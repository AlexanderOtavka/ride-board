Rails.application.routes.draw do
  root to: "welcome#index"

  devise_for :users
  resources :locations

  get "/s/:id", to: redirect('/passenger/rides/%{id}'), as: :share_ride

  namespace :passenger do
    root to: "rides#index"

    get    "/rides/mine",     to: "rides#mine",  as: :my_rides
    post   "/rides/:id/join", to: "rides#join",  as: :join_ride
    delete "/rides/:id/join", to: "rides#leave"
    resources :rides do
      resources :messages, as: :messages, only: [:create]
    end
  end

  namespace :driver do
    root to: "rides#index"

    get    "/rides/mine",     to: "rides#mine",  as: :my_rides
    post   "/rides/:id/join", to: "rides#join",  as: :join_ride
    delete "/rides/:id/join", to: "rides#leave"
    resources :rides do
      resources :messages, as: :messages, only: [:create]
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
