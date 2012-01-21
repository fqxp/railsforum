class ApplicationController < ActionController::Base
  protect_from_forgery
#  before_filter :authorize
  before_filter :authenticate_user!
  before_filter :populate_categories
#  before_filter :set_current_user
#  before_filter :set_locale_from_user
  
protected
  def populate_categories
    @categories = Category.all
  end
  
private
  # Set locale from logged-in user information
  def set_locale_from_user
    if user_signed_in?
      begin
        I18n.locale = current_user.language
      rescue ActiveRecord::RecordNotFound
        I18n.locale = extract_locale_from_accept_language_header || I18n.default_locale
      end
    else
      I18n.locale = extract_locale_from_accept_language_header || I18n.default_locale
    end
  end  

  def with_owner_only(document)
    if document.user.id == current_user[:id]
      yield document
    else
      respond_to do |format|
        format.html { redirect_to login_url, :notice => I18n.t('.please_log_in') }
        format.json { head :forbidden }
      end
    end
  end

  def extract_locale_from_accept_language_header
    if request.env.has_key? 'HTTP_ACCEPT_LANGUAGE'
      request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    end
  end
end
