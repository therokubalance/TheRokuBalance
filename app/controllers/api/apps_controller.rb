module Api
  class AppsController < Api::ApplicationController
    before_action :authenticate_token!
    def create
      user = User.new()
      render json: {yeahy: "goes ok!"}, status: :ok
    end
  end
end
