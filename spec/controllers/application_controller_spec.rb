require 'spec_helper'

describe ApplicationController do

  after do
    I18n.locale = nil
  end

  describe 'set_locale_from_user for public view' do
    no_logged_in_user

    controller do
      before_filter :authenticate_user!, :except => [:index]

      def index
        render :text => 'foobar'
      end
    end

    it 'should set the locale to the default locale for public page if none is specified in HTTP headers' do
      I18n.default_locale = :xy

      get :index
      response.should be_success

      I18n.locale.should == :xy
    end

    it "should set the locale to the locate given in accept-language HTTP header if present" do
      I18n.default_locale = :xy
      request.env['HTTP_ACCEPT_LANGUAGE'] = 'ab-cd, ab'

      get :index

      I18n.locale.should == :ab
    end
  end

  context "logged-in user" do
    controller do
      def index
        render :text => 'foobar'
      end
    end

    describe "set_locale_from_user for private view" do
      login_user(:language => :de)

      it "should set the locale to the user's locale" do
        get :index

        I18n.locale.should == :de
      end
    end

    describe "populate_categories" do
      login_user

      it "should populate @categories by default" do
        Factory.create(:category)
        get :index

        assigns(:categories).should_not be_nil
      end
    end
  end

end
