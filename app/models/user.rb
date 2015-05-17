# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  auth_token             :string
#  available_invitations  :integer          default(2)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  attr_accessor :invitation_token
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validate :validate_invitations, on: :create
  has_many :apps
  has_one :invitation
  before_create :generate_auth_token
  after_create :assign_invitation

  def generate_auth_token
    begin
      self.auth_token = SecureRandom.urlsafe_base64
    end while User.exists?(auth_token: self.auth_token)
  end
  private
  def assign_invitation
    invitation = Invitation.where(token: self.invitation_token).take
    invitation.user_id = self.id
    invitation.save
  end
  def validate_invitations 
    invitation = Invitation.where(token: self.invitation_token, user_id: self.id).take
    unless (invitation)
      errors.add(:invitation, " was invalid")
    end
  end

end
