class Talk < ActiveRecord::Base
  validates :category_id, :presence => true
  validates :title, :presence => true
  belongs_to :category
  belongs_to :user
  has_many :posts
  has_many :talk_visits
  
  attr_accessor :count_unread_posts
  attr_accessor :latest_post_at

  # Return a list of talks enriched with information interesting to the user, and
  # sorted by the last message posted to a talk.
  # Fields added to each talk:
  # * count_posts
  # * latest_post_at
  # * count_unread_posts
  def self.talks_with_user_specific_info(current_user_id, page=nil, category_id=nil)
    talks = self
    talks = talks.where(:category_id => category_id) unless category_id.nil?
    talks = talks \
      .select('talks.*, COUNT(posts.id) AS count_posts, MAX(posts.updated_at) AS latest_post_at_s') \
      .includes(:category, :talk_visits, :posts => :user) \
      .joins(:posts) \
      .joins("LEFT JOIN talk_visits ON talk_visits.talk_id=talks.id AND talk_visits.user_id=#{current_user_id}")
      .group('posts.talk_id') \
      .order('latest_post_at_s DESC') \
      .page(page)
      
    talks.each do |talk|
      # The following seems to be database-specific:
      # sqlite returns a string, while MySQL::Time object - we're trying
      # to be on the safe side
      talk.latest_post_at = DateTime.parse(talk['latest_post_at_s'].to_s)
      talk.add_count_unread_posts! current_user_id
    end
    
    talks
  end

  def add_count_unread_posts!(current_user_id)
    talk_visit = talk_visits.find_by_user_id(current_user_id)
    self.count_unread_posts = talk_visit.nil? ? 0 : Post.where(:talk_id => id) \
      .where('updated_at > ?', talk_visit.last_visited).count
  end
end
