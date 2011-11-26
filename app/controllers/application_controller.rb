class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authorize
  before_filter :populate_categories
  before_filter :set_current_user
  before_filter :set_locale_from_user
  
  protected
    def populate_categories
      @categories = Category.all
    end
    
    def set_current_user
      if session[:user_id]
        @current_user = User.find(session[:user_id])
      end
    end

    def set_locale_from_user
      if session[:user_id]
        begin
          I18n.locale = @current_user.language
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
