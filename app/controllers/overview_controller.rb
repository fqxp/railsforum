class OverviewController < ApplicationController
  def index
    @current_talks = Talk.includes(:posts).order('posts.updated_at DESC').limit(25)
  end
end
