class OverviewController < ApplicationController
  def index
    @current_talks = Talk.talks_with_user_specific_info(session[:user_id])
  end
end
