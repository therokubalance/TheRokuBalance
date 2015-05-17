class InvitationRequestsController < ApplicationController

  def new
    @invitation_request = InvitationRequest.new
  end

  def create
    @invitation_request = InvitationRequest.new(invitation_request_params)
    if @invitation_request.save
      flash[:notice] = "We'll send you and invitation code as soon as possible :)."
      redirect_to root_path
    else
      render :new
    end
  end

  protected

  def invitation_request_params
    params.require(:invitation_request).permit(:email)
  end

end
