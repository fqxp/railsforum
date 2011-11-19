class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authorize
  before_filter :populate_topics
  before_filter :set_locale_from_user
  
  def populate_topics
    @topics = Topic.all
  end

  protected
    def set_locale_from_user
      if session[:user_id]
        begin
          user = User.find(session[:user_id])
          I18n.locale = user.language
        rescue ActiveRecord::RecordNotFound
          I18n.locale = I18n.default_locale
        end
      else
        I18n.locale = I18n.default_locale
      end
    end  
  
  private
    def authorize
      unless User.find_by_id(session[:user_id])
        redirect_to login_url, :notice => "Please log in"
      end
    end

end
