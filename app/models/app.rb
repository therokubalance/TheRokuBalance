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
  validates :url1, presence: true
  validates :url2, presence: true
  validates :subdomain, presence: true, uniqueness: true
  belongs_to :user
  after_validation :strip_herokudomain
  after_create :register_app

  APPS_AVAILABLE_DIR = ENV["APPS_AVAILABLE_DIR"] || "tmp/apps_available"
  APPS_ENABLED_DIR = ENV["APPS_ENABLED_DIR"] || "tmp/apps_enabled"
  def switch
    puts "switched"
  end

  def strip_herokudomain
    self.url1.gsub!('.herokuapp.com','') if self.url1 != nil
    self.url2.gsub!('.herokuapp.com','') if self.url2 != nil

  end

  def register_app
    site_available = File.join(APPS_AVAILABLE_DIR,"#{self.subdomain}.therokubalance.com")
    site_enabled = File.join(APPS_ENABLED_DIR,"#{self.subdomain}.therokubalance.com")
    File.open(site_available, 'w') do |f|
      f.puts %Q(
server {
  server_name #{subdomain}.therokubalance.com;
  location / {
    proxy_pass  http://#{url1}.herokuapp.com;
  }
}
      )
    end
    system "ln -s #{site_available} #{site_enabled}"
    system "nginx -s reload"
  end
end
