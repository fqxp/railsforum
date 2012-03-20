require 'spec_helper'

describe TalksController do

  login_user

  describe 'GET show' do
    before do
      @talk = Factory.create(:talk)
      @post_1 = Factory.create(:post, :talk => @talk, :created_at => DateTime.new(2011, 2, 3, 4, 5, 6))
      @post_2 = Factory.create(:post, :talk => @talk, :created_at => DateTime.new(2011, 2, 3, 4, 5, 7))
    end

    it "should load the correct talk" do
      get :show, :id => @talk.id

      assigns(:talk).id.should == @talk.id
    end

    it "should provide posts in the correct order" do
      get :show, :id => @talk.id

      assigns(:posts).first.id.should == @post_1.id
      assigns(:posts).second.id.should == @post_2.id
    end

    it "should provide the current category" do
      get :show, :id => @talk.id

      assigns(:current_category).id.should == @talk.category.id
    end

    it "should provide a new post with preset talk" do
      get :show, :id => @talk.id

      assigns(:post).should be_new_record
      assigns(:post).talk_id.should == @talk.id
    end

    it "should mark the current talk as visited" do
      Talk.any_instance.should_receive(:mark_visited).with(controller.current_user.id)

      get :show, :id => @talk.id
    end
  end

  describe "GET new" do
    before do
      @category = Factory.create(:category)
    end

    it "should provide a talk with preset category id if category_id was given" do
      get :new, :category_id => @category.id

      assigns(:talk).should be_new_record
      assigns(:talk).category_id.should == @category.id
    end

    it "should provide a talk with no category id if no category_id was given" do
      get :new

      assigns(:talk).should be_new_record
      assigns(:talk).category_id.should be_nil
    end

    it "should provide a new post" do
      get :new, :category_id => @category.id

      assigns(:post).should_not be_nil
      assigns(:post).should be_new_record
    end
  end

  describe "POST create" do
    before do
      @category = Factory.create(:category)

      @talk_data = {
        "title" => "Talk title",
        "category_id" => @category.id
      }
      @post_data = {
        "text" => "Some text"
      }
    end

    it "should save a new talk and a new post" do
      post :create, :talk => @talk_data, :post => @post_data

      new_talk = Talk.first
      new_post = Post.first

      new_talk.title.should == "Talk title"

      new_post.talk.id.should == new_talk.id
      new_post.text.should == "Some text"
    end

    it "should re-render the form if talk is not valid" do
      Talk.any_instance.should_receive(:"valid?").and_return(false)

      post :create, :talk => @talk_data, :post => @post_data

      response.should render_template(:new)
    end

    it "should re-render the form if post is not valid" do
      Post.any_instance.should_receive(:"valid?").and_return(false)

      post :create, :talk => @talk_data, :post => @post_data

      response.should render_template(:new)
    end

    it "should save talk with user id of current user" do
      post :create, :talk => @talk_data, :post => @post_data

      Talk.first.user_id == controller.current_user.id
    end

    it "should save post with user id of current user" do
      post :create, :talk => @talk_data, :post => @post_data

      Post.first.user_id == controller.current_user.id
    end
  end
end
