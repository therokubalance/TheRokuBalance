# == Schema Information
#
# Table name: apps
#
#  id         :integer          not null, primary key
#  url1       :string
#  url2       :string
#  subdomain  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class App < ActiveRecord::Base
  SUBDOMAIN_REGEX = /\A[a-z]{2,}[a-z0-9-_]+\Z/i

  validates :user, presence: true
  validates :url1, presence: true, format: {with: SUBDOMAIN_REGEX }
  validates :url2, presence: true, format: {with: SUBDOMAIN_REGEX }
  validates :subdomain, presence: true, uniqueness: true, format: {with: SUBDOMAIN_REGEX }

  belongs_to :user
  after_validation :strip_herokudomain
  after_create :register_app
  after_update :update_app
  after_destroy do |app|
    delete_nginx_config_file(app.subdomain)
    reload_nginx
  end

  APPS_AVAILABLE_DIR = ENV["APPS_AVAILABLE_DIR"] || "tmp/apps_available"
  APPS_ENABLED_DIR = ENV["APPS_ENABLED_DIR"] || "tmp/apps_enabled"

  def strip_herokudomain
    self.url1.gsub!('.herokuapp.com','') if self.url1 != nil
    self.url2.gsub!('.herokuapp.com','') if self.url2 != nil
    create_nginx_config_file
  end

  private

  def register_app
    create_nginx_config_file
    reload_nginx
  end

  def update_app
    delete_nginx_config_file(self.subdomain_was)
    create_nginx_config_file
    reload_nginx
  end

  def delete_nginx_config_file(subdomain=nil)
    logger.info "Deleting * #{self.subdomain_was}.therokubalance.com *..."
    subdomain ||= self.subdomain
    site_available = File.join(APPS_AVAILABLE_DIR,"#{subdomain}.therokubalance.com")
    site_enabled = File.join(APPS_ENABLED_DIR,"#{subdomain}.therokubalance.com")

    File.delete(site_available)
    File.delete(site_enabled)
  end

  def create_nginx_config_file(opts={})
    logger.info "Creating * #{self.subdomain}.therokubalance.com *..."
    opts[:subdomain] ||= self.subdomain
    opts[:url1] ||= self.url1
    opts[:url2] ||= self.url2

    site_available = File.join(APPS_AVAILABLE_DIR,"#{opts[:subdomain]}.therokubalance.com")
    site_enabled = File.join(APPS_ENABLED_DIR,"#{opts[:subdomain]}.therokubalance.com")
    File.open(site_available, 'w') do |f|
      f.puts %Q(
server {
  server_name #{opts[:subdomain]}.therokubalance.com;
  location / {
    proxy_pass  http://#{opts[:url1]}.herokuapp.com;
  }
}
      )
    end
    system "ln -s #{site_available} #{site_enabled}"
  end

  def reload_nginx
    system "nginx -s reload"
  end
end
