require 'bb-ruby'

class Post < ActiveRecord::Base
  default_scope :order => 'created_at'
  validates :text, :presence => true
  validates :talk_id, :presence => true
  belongs_to :user
  belongs_to :talk
  attr_accessible :text, :talk_id, :created_at, :updated_at, :user_id, :attachment

  has_attached_file :attachment, :styles => {:thumb => '150x150'}

  #attr_reader rendered_text

  def rendered_text
    self.text.bbcode_to_html.html_safe
  end
end
