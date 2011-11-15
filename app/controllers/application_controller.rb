class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authorize
  before_filter :populate_topics
  
  def populate_topics
    @topics = Topic.all
  end
  
  private
  
    def authorize
      unless User.find_by_id(session[:user_id])
        redirect_to login_url, :notice => "Please log in"
      end
    end

end
