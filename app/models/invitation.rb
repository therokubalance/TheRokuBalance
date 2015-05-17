# == Schema Information
#
# Table name: invitations
#
#  id         :integer          not null, primary key
#  token      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class Invitation < ActiveRecord::Base
end
