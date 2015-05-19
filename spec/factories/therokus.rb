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

FactoryGirl.define do
  factory :theroku do
    variable "MyString"
value "MyString"
  end

end
