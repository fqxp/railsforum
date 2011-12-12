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
        begin
          @current_user = User.find(session[:user_id])
        rescue ActiveRecord::RecordNotFound
          session[:user_id] = nil
          @current_user = nil
        end
      end
    end

private
  # Set locale from logged-in user information
  def set_locale_from_user
    if session[:user_id]
      begin
        I18n.locale = @current_user.language
      rescue ActiveRecord::RecordNotFound
        I18n.locale = extract_locale_from_accept_language_header
      end
    else
      I18n.locale = extract_locale_from_accept_language_header
    end
  end  

  def authorize
    unless User.find_by_id(session[:user_id])
      respond_to do |format|
        format.html { redirect_to login_url, :notice => I18n.t('.please_log_in') }
        format.json { head :forbidden }
      end
    end
  end

  def with_owner_only(document)
    if document.user.id == session[:user_id]
      yield document
    else
      respond_to do |format|
        format.html { redirect_to login_url, :notice => I18n.t('.please_log_in') }
        format.json { head :forbidden }
      end
    end
  end

  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end
end
