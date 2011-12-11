require 'bb-ruby'

class PreviewController < ActionController::Base
  def bbcode
    text = params[:text].to_s
    @rendered_text = text.bbcode_to_html
  end
end