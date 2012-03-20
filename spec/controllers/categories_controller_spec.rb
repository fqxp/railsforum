require 'spec_helper'

describe CategoriesController do

  login_user

  describe 'GET show' do
    it 'populates @talks and the current category' do
      category = Factory.create(:category)

      get :show, :id => category.id

      response.should be_success

      assigns(:current_category).id.should == category.id
      assigns(:talks).should_not be_nil
    end
  end

end
