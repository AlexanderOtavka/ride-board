Rails.application.routes.draw do
  root to: "welcome#index"

  as :user do
    patch '/user/confirmation' => 'confirmations#update', :via => :patch, :as => :update_user_confirmation
  end

  devise_for :users, path: 'account', controllers: {
               registrations: 'users/registrations',
               confirmations: "confirmations",
               sessions: "users/sessions"
  }
  resources :locations

  get "/s/:ride_id", to: "welcome#share", as: :share_ride
  get "/d/:id", to: redirect('/driver/rides/%{id}'), as: :short_driver_ride
  get "/p/:id", to: redirect('/passenger/rides/%{id}'), as: :short_passenger_ride

  namespace :passenger do
    root to: "rides#index"

    get "/me", to: "me#show", as: :me

    resource :notifications, as: :notify, only: [:show, :update]

    post   "/rides/:id/join", to: "rides#join", as: :join_ride
    delete "/rides/:id/join", to: "rides#leave"
    resources :rides do
      resources :messages, only: [:create]
      resource :ride_notifications, as: :notify, path: "notifications",
                                    only: [:show, :update]
    end
  end

  namespace :driver do
    root to: "rides#index"

    get "/me", to: "me#show", as: :me

    resource :notifications, as: :notify, only: [:show, :update]

    post   "/rides/:id/join", to: "rides#join", as: :join_ride
    delete "/rides/:id/join", to: "rides#leave"
    resources :rides do
      resources :messages, as: :messages, only: [:create]
      resource :ride_notifications, as: :notify, path: "notifications",
                                    only: [:show, :update]
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
