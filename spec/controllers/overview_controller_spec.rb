require 'spec_helper'

describe OverviewController do

  login_user

  describe 'GET index' do
    it 'populates @current_talks with a list of current talks' do
      get :index

      response.should be_success

      assigns(:current_talks).should_not be_nil
    end
  end

end
