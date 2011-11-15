class Post < ActiveRecord::Base
  default_scope :order => 'created_at'
  validates :text, :presence => true
  validates :talk_id, :presence => true
  belongs_to :user
  belongs_to :talk
end
