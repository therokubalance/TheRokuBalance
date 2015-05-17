desc "call method to change the app"
task :app_changer => :environment do
  apps = App.all
  apps.each do |app|  
    app.switch
  end
end
