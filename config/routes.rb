Rails.application.routes.draw do
  authenticated :user do
    root :to => "apps#new", :as => "authenticated_root"
    # Rails 4 users must specify the 'as' option to give it a unique name
    # root :to => "main#dashboard", :as => "authenticated_root"
    resource :apps
  end
  root 'users#index'
  devise_for :users, path: "auth", path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification', unlock: 'unblock', registration: 'register', sign_up: 'cmon_let_me_in' }
  resource :users, only: [:index]
end
