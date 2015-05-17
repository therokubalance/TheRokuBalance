class AppsController < ApplicationController
  def new
    @app = App.new
  end

  def create
    @app = App.new(app_params)
    @app.user_id = current_user.id
    if @app.save
      flash[:notice] = "Successful app register"
      redirect_to apps_path
    else
      render "new"
    end
  end

  def index
    @apps = App.where(user_id: current_user.id)
  end
  private
  def app_params
    params.require(:app).permit(:url1,:url2,:subdomain)    
  end
end
