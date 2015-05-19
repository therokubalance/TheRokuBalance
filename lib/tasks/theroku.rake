namespace :theroku do
  desc "Switch theroku apps"
  task switch_apps: :environment do
    Rails.logger.info "Switching apps..."
    App.switch_apps
    Rails.logger.info "... Apps switched"
  end
end
