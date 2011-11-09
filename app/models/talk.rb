class Talk < ActiveRecord::Base
  validates :topic_id, :presence => true
  validates :title, :presence => true
  belongs_to :topic
  has_many :posts
end
