class InvitationsController < ApplicationController
  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params)
    if @invitation.save
      Invitation.invitation_token_email(@invitation).deliver
      redirect_to action: "index"
    else
      render "new"
    end

  end
  private
  def invitation_params
    params.require(:invitation).permit(:email)
  end
end
