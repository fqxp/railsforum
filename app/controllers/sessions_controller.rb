class SessionsController < ApplicationController
  skip_before_filter :authorize
  
  def new
  end

  def create
    debugger
    if user = User.authenticate(params[:username], params[:password])
      session[:user_id] = user.id
      redirect_to overview_index_url
    else
      session.delete :user_id
      redirect_to login_url, :alert => "Invalid password or username"
    end
  end

  def destroy
    session.delete :user_id
    redirect_to login_url, :notice => "Logged out"
  end
end
