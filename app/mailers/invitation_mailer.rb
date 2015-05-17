class InvitationMailer < ApplicationMailer
  default from: "no-reply@theroku.com"
  def token_invitation_email(invitation)
    @invitation = invitation
    mail(to: @invitation.email,
       subject: 'Invitation to therokuapp.com') 
  end
end
