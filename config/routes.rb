Rails.application.routes.draw do
  root to: "welcome#index"

  devise_for :users
  resources :locations

  get "/s/:id", to: redirect('/passenger/rides/%{id}'), as: :share_ride
  get "/d/:id", to: redirect('/driver/rides/%{id}'), as: :short_driver_ride

  namespace :passenger do
    root to: "rides#index"

    get   "/notify", to: "notifications#show", as: :notify
    patch "/notify", to: "notifications#update"

    get    "/myrides",        to: "rides#mine", as: :my_rides
    post   "/rides/:id/join", to: "rides#join", as: :join_ride
    delete "/rides/:id/join", to: "rides#leave"
    resources :rides do
      resources :messages, as: :messages, only: [:create]

      get   "/notify", to: "ride_notifications#show", as: :notify
      patch "/notify", to: "ride_notifications#update"
    end
  end

  namespace :driver do
    root to: "rides#index"

    get   "/notify", to: "notifications#show", as: :notify
    patch "/notify", to: "notifications#update"

    get    "/myrides",        to: "rides#mine", as: :my_rides
    post   "/rides/:id/join", to: "rides#join", as: :join_ride
    delete "/rides/:id/join", to: "rides#leave"
    resources :rides do
      resources :messages, as: :messages, only: [:create]

      get   "/notify", to: "ride_notifications#show", as: :notify
      patch "/notify", to: "ride_notifications#update"
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
