desc "call method to switch the apps"
task :app_changer => :environment do
  App.switch_apps
end
