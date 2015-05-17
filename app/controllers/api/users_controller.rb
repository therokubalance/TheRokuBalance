module Api
  class UsersController < ApplicationController
    def index
      render nothing: true
    end
    def login
      
    end
    def create

      user = User.new(article_params)
    end

    private
    def user_params
      params.require(:app).permit(:app1,:app2,:subdomain)    
    end

  end
end