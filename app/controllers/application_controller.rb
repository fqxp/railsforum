class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :populate_topics
  
  def populate_topics
    @topics = Topic.all
  end
end
