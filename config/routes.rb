Rails.application.routes.draw do


  authenticated :user do

    root :to => "apps#index", :as => "authenticated_root"
    resources :apps
    resources :invitations, only: [:new, :create]
  end

  root 'pages#index'

  devise_for :users
  resources :invitation_requests, only: [:create,:new]
  namespace :api do
    resources :apps ,only:[:create, :update, :destroy, :index]
    post "/login" => 'users#login'
  end
end
