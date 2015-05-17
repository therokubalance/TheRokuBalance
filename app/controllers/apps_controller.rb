class AppsController < ApplicationController
  before_action :set_app, only: [:update,:edit,:destroy]
  before_action :set_apps, only: [:index,:edit,:update,:create]

  def index
    @app = App.new
  end


  def create
    @app = App.new(app_params)
    @app.user_id = current_user.id
    if @app.save
      flash[:notice] = "App registered"
      redirect_to apps_path
    else
      render :index
    end
  end

  def edit
  end

  def update
    if @app.update(app_params)
      flash[:notice] = "App updated"
      redirect_to apps_path
    else
      puts "hola"
      render :edit
    end
  end

  def destroy
    @app.destroy
    flash[:notice] = "Application Deleted"
    redirect_to apps_path
  end

  private

  def set_apps
    @apps = current_user.apps
  end

  def set_app
    @app = current_user.apps.find_by_subdomain(params[:id])
    @app ||= current_user.apps.find(params[:id])
  end

  def app_params
    params.require(:app).permit(:url1,:url2,:subdomain)
  end

end
