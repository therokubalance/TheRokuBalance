Rails.application.routes.draw do
  authenticated :user do

    root :to => "apps#index", :as => "authenticated_root"
    resources :apps
  end

  root 'users#index'
  
  devise_for :users
  resources :users, only: [:index]
  namespace :api do
    resources :apps ,only:[:create, :update, :destroy]
    post "/login" => 'users#login'
  end
end
