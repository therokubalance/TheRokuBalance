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

require 'rails_helper'

RSpec.describe Theroku, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
