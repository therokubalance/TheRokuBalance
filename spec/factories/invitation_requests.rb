# == Schema Information
#
# Table name: invitation_requests
#
#  id         :integer          not null, primary key
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :invitation_request do
    email "MyString"
  end

end
