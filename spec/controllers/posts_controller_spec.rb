require 'spec_helper'

describe PostsController do

  login_user

  before do
    @talk = Factory.create(:talk)
  end

  describe 'POST create' do
    before do
      @post_data = {
        "text" => "Some text",
        "talk_id" => @talk.id
      }
    end

    it "saves a new post" do
      post :create, "post" => @post_data

      new_post = Post.first
      new_post.user.id.should == controller.current_user.id
      new_post.text.should == "Some text"
      new_post.talk_id.should == @talk.id
    end

    it "sets a flash notice when save was successful" do
      Post.any_instance.should_receive(:save).and_return(true)

      post :create, "post" => @post_data

      flash.now[:notice].should == I18n.t("posts_controller.post_successfully_created")
    end

    it "sets a flash notice when save failed" do
      Post.any_instance.should_receive(:save).and_return(false)

      post :create, "post" => @post_data

      flash.now[:error].should == I18n.t("posts_controller.post_create_failed")
    end

    it "marks the talk the post is part of as visited" do
      Talk.any_instance.should_receive(:mark_visited).with(controller.current_user.id)

      post :create, "post" => @post_data
    end

    it "redirects to the current talk and post if save was successful" do
      Post.any_instance.should_receive(:save).and_return(true)

      post :create, "post" => @post_data

      response.should redirect_to(talk_path(@talk, :anchor => "current"))
    end

    it "redirects to the current talk if save failed" do
      Post.any_instance.should_receive(:save).and_return(false)

      post :create, "post" => @post_data

      response.should redirect_to(talk_path(@talk))
    end
  end

  describe "PUT update" do
    before do
      @post = Factory.create(:post, :talk => @talk, :user => controller.current_user)
    end

    it "should update the post attributes" do
      Post.any_instance.should_receive(:update_attributes).with({"text" => "Some other text"})

      put :update, :id => @post.id, :post => {"text" => "Some other text"}
    end

    it "should set a notice when update was successful" do
      Post.any_instance.should_receive(:update_attributes).and_return(true)

      put :update, :id => @post.id, :post => {:text => "Some other text"}

      flash.now[:notice].should == I18n.t("posts_controller.post_successfully_updated")
    end

    it "should set a notice when update failed" do
      Post.any_instance.should_receive(:update_attributes).and_return(false)

      put :update, :id => @post.id, :post => {:text => ""}

      flash.now[:error].should == I18n.t("posts_controller.post_update_failed")
    end

    it "should redirect to current talk and post when update was successful" do
      Post.any_instance.should_receive(:update_attributes).and_return(true)

      put :update, :id => @post.id, :post => {:text => "Some other text"}

      response.should redirect_to(talk_path(@talk, :anchor => "current"))
    end

    it "should redirect to current talk when update failed" do
      Post.any_instance.should_receive(:update_attributes).and_return(false)

      put :update, :id => @post.id, :post => {:text => "Some other text"}

      response.should redirect_to(talk_path(@talk))
    end

    it "should fail when trying to change another user's post" do
      other_users_post = Factory.create(:post)

      put :update, :id => other_users_post.id, :post => {:text => "Some other text"}

      response.code.should == "403"
    end
  end

  describe "DELETE destroy" do
    before do
      @post = Factory.create(:post, :talk => @talk, :user => controller.current_user)
    end

    it "should delete post" do
      delete :destroy, :id => @post.id

      expect {
        Post.find(@post.id).should be_nil
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "should not delete other user's post" do
      other_users_post = Factory.create(:post)

      delete :destroy, :id => other_users_post.id
    end

    it "should redirect to talk page if successful" do
      delete :destroy, :id => @post.id

      response.should redirect_to(talk_path(@talk))
    end
  end
end
