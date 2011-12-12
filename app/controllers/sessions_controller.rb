class SessionsController < ApplicationController
  skip_before_filter :authorize
  
  def new
  end

  def create
    if user = User.authenticate(params[:username], params[:password])
      session[:user_id] = user.id
      redirect_to overview_index_url
    else
      session.delete :user_id
      redirect_to login_url, :notice => I18n.t('.invalid_password')
    end
  end

  def destroy
    session.delete :user_id
    redirect_to login_url, :notice => I18n.t('.logged_out')
  end
end
