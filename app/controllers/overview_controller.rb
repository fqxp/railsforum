class OverviewController < ApplicationController
  def index
    @current_talks = Talk.talks_with_user_specific_info(current_user[:id], params[:page])
  end
end
