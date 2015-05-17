module Api
  class AppsController < Api::ApplicationController
    before_action :authenticate_token!
    def create
      app = App.new(app_params)
      app.user_id = @current_user.id
      if app.save
        render json: {Tryceratops: "created"}, status: :ok
      else
        render json: {errors: "couldn't save the app"}, status: 417 
      end
    end
    private
    def app_params
      params.permit(:url1, :url2, :subdomain)
    end
  end
end
