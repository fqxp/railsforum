class RegistrationController < ApplicationController
  def registration
    session.delete(:user_id)
    invitation = Invitation.where(:confirm_key => params[:confirm_key]).first
    @user = User.new do |u|
      u.email_address = invitation.email_address
    end
    render
  end
  
  def register
    @user = User.new(params[:user])
    if @user.save
      redirect_to edit_user_url(@user)
    else
      render 'registration'
    end
  end
end