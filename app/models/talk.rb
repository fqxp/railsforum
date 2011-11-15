class Talk < ActiveRecord::Base
  validates :topic_id, :presence => true
  validates :title, :presence => true
  belongs_to :topic
  belongs_to :user
  has_many :posts
end
