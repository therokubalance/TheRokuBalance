Rails.application.routes.draw do
  authenticated :user do
    root :to => "apps#new", :as => "authenticated_root"
    resource :apps
  end

  devise_for :users

  resource :users, only: [:index]

  root 'users#index'
end
