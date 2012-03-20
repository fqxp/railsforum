require 'spec_helper'

describe OverviewController do

  login_user

  describe 'GET index' do
    it 'should be successful without condition' do
      get :index

      response.should be_success
    end
  end
end
