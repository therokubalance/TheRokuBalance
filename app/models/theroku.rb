# == Schema Information
#
# Table name: therokus
#
#  id         :integer          not null, primary key
#  variable   :string
#  value      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Theroku < ActiveRecord::Base

  def self.active_url
    Theroku.find_by_variable("active_url").value
  end

  def self.active_url=(url)
    var = Theroku.find_by_variable("active_url")
    var.value = url
    var.save
  end

end
