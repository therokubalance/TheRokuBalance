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

  THEROKU_SWITCHER_PATH = ENV["THEROKU_SWITCHER_PATH"] || "tmp/theroku_switcher.conf"
  SITES_ENABLED_HALF_1 = ENV["SITES_ENABLED_HALF_1"] || "tmp/sites_enabled_half_1"
  SITES_ENABLED_HALF_2 = ENV["SITES_ENABLED_HALF_2"] || "tmp/sites_enabled_half_2"

  validates :user, presence: true
  validates :url1, presence: true, format: {with: SUBDOMAIN_REGEX }
  validates :url2, presence: true, format: {with: SUBDOMAIN_REGEX }
  validates :subdomain, presence: true, uniqueness: true, format: {with: SUBDOMAIN_REGEX }

  belongs_to :user
  after_create :register_app
  after_update :update_app
  after_destroy do |app|
    delete_nginx_config_file(app.subdomain)
    App.reload_nginx
  end

  def self.switch_apps
    current = File.open(THEROKU_SWITCHER_PATH, &:readline)
    if current.chomp.strip == "#1"
      File.open(THEROKU_SWITCHER_PATH, 'w') do |f|
        f.puts "#2"
        f.puts "include #{File.join(SITES_ENABLED_HALF_2,'*')};"
      end
    else
      File.open(THEROKU_SWITCHER_PATH, 'w') do |f|
        f.puts "#1"
        f.puts "include #{File.join(SITES_ENABLED_HALF_1,'*')};"
      end
    end
    App.reload_nginx
  end

  private

  def register_app
    create_nginx_config_file
    App.reload_nginx
  end

  def update_app
    delete_nginx_config_file(self.subdomain_was)
    create_nginx_config_file
    App.reload_nginx
  end

  def delete_nginx_config_file(subdomain=nil)
    logger.info "Deleting * #{self.subdomain_was}.therokubalance.com *..."
    subdomain ||= self.subdomain

    conf_file1 = site_conf_file(1,subdomain)
    conf_file2 = site_conf_file(2,subdomain)
    begin
      File.delete(conf_file1)
    rescue Errno::ENOENT => e
      logger.warn "conf file for site * #{self.subdomain} * doesn't exist (half1)"
    end

    begin
      File.delete(conf_file2)
    rescue Errno::ENOENT => e
      logger.warn "conf file for site * #{self.subdomain} * doesn't exist (half2)"
    end

  end

  def create_nginx_config_file(opts={})
    logger.info "Creating * #{self.subdomain}.therokubalance.com *..."
    opts[:subdomain] ||= self.subdomain
    opts[:url1] ||= self.url1
    opts[:url2] ||= self.url2

    conf_file1 = site_conf_file(1,opts[:subdomain])
    conf_file2 = site_conf_file(2,opts[:subdomain])

    File.open(conf_file1, 'w') do |f|
      f.puts subdomain_conf(url: opts[:url1])
    end
    File.open(conf_file2, 'w') do |f|
      f.puts subdomain_conf(url: opts[:url2])
    end
  end

  def self.reload_nginx
    system "nginx -s reload"
  end

  def site_conf_file(half,subdomain)
    File.join(
      [SITES_ENABLED_HALF_1,SITES_ENABLED_HALF_2][half-1],
      "#{subdomain}.therokubalance.com"
    )
  end

  def subdomain_conf(opts={})
    opts[:subdomain] ||= self.subdomain
    opts[:url] ||= self.url1
    %Q(
server {
  server_name #{opts[:subdomain]}.therokubalance.com;
  location / {
    proxy_pass  http://#{opts[:url]}.herokuapp.com;
  }
}
    )
  end
end
