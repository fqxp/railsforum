class Talk < ActiveRecord::Base
  validates :category_id, :presence => true
  validates :title, :presence => true
  belongs_to :category
  belongs_to :user
  has_many :posts
end
