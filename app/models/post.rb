require 'bb-ruby'

class Post < ActiveRecord::Base
  default_scope :order => 'created_at'
  validates :text, :presence => true
  validates :talk_id, :presence => true
  belongs_to :user
  belongs_to :talk
  #attr_reader rendered_text

  def rendered_text
    self.text.bbcode_to_html.html_safe
  end
end
