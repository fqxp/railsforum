class RegistrationController < ApplicationController
  skip_before_filter :authorize

  def registration
    session[:user_id] = nil
    invitation = Invitation.where(:confirm_key => params[:confirm_key]).first
    @confirm_key = params[:confirm_key]
    @user = User.new do |u|
      u.email_address = invitation.email_address
    end
    render 'registration'
  end
  
  def register
    @user = User.new(params[:user])
    @confirm_key = params[:confirm_key]
    if @user.save
      Invitation.where(:confirm_key => params[:confirm_key]).delete_all
      session[:user_id] = @user.id
      redirect_to edit_user_url(@user)
    else
      render 'registration'
    end
  end
end