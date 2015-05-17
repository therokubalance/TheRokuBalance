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

require 'rails_helper'

RSpec.describe App, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
