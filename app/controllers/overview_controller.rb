class OverviewController < ApplicationController
  def index
    @topics = Topic.all
    @current_talks = Talk.includes(:posts).order('posts.updated_at DESC').limit(10)
  end

end
