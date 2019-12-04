Rails.application.routes.draw do
  root to: "welcome#index"

  namespace :passenger do
    root to: "rides#index"

    resources :rides do
      resources :messages, as: :messages, only: [:create]
    end
    post   "/rides/:id/join", to: "rides#join",  as: :join_ride
    delete "/rides/:id/join", to: "rides#leave"
  end

  get "/s/:id", to: redirect('/passenger/rides/%{id}'), as: :share_ride

  namespace :driver do
    root to: "rides#index"

    resources :rides do
      resources :messages, as: :messages, only: [:create]
    end
    post   "/rides/:id/join", to: "rides#join",  as: :join_ride
    delete "/rides/:id/join", to: "rides#leave"
  end

  devise_for :users
  resources :locations

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
