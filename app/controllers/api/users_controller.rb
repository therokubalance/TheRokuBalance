module Api
  class UsersController < ApplicationController
    before_action :authenticate_token!, except: [:login]

    def login
      user = User.find_by_email(params[:email])
      if user && user.valid_password?(params[:password])
        render json: {auth_token: user.auth_token}, status: :ok
      else
        render json: {errors: "Unauthorized!"}, status: :unauthorized
      end
    end
  end
end