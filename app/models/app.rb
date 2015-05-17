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
#

class App < ActiveRecord::Base
  validates :url1, presence: true
  validates :url2, presence: true
  validates :subdomain, presence: true
  belongs_to :user
  after_validation :strip_herokudomain

  def strip_herokudomain
    self.url1.gsub!('.herokuapp.com','') if self.url1 != nil
    self.url2.gsub!('.herokuapp.com','') if self.url2 != nil
  end
end
