Rails.application.routes.draw do
  authenticated :user do
    root :to => "apps#index", :as => "authenticated_root"
    resources :apps
  end

  devise_for :users

  resources :users, only: [:index]

  root 'users#index'
end
