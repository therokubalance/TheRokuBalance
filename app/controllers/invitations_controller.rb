class InvitationsController < ApplicationController
  def new
    @invitation = Invitation.new
    if current_user.available_invitations <= 0
      redirect_to authenticated_root_path
    end
  end

  def create
    if current_user.available_invitations > 0 
      @invitation = Invitation.new(invitation_params)
      if @invitation.save
        InvitationMailer.token_invitation_email(@invitation).deliver
        current_user.available_invitations -= 1
        current_user.save
        redirect_to authenticated_root_path
      else
        render "new"
      end
    else
      redirect_to authenticated_root_path
    end
  end

  private
  def invitation_params
    params.require(:invitation).permit(:email)
  end
end
