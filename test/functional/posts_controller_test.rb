require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  setup do
    @post = posts(:one)
    @post_from_other_user = posts(:two)
  end

  test "should get new" do
    get :new, { :talk_id => talks(:one).id }
    assert_response :success
  end

  test "should create post" do
    @post.text = 'my newly created post'
    assert_difference('Post.count') do
      post :create, post: @post.attributes
    end
    
    assert_redirected_to talk_path(@post.talk, :anchor => 'current')

    new_post = Post.where(:text => 'my newly created post').first
    assert_not_nil new_post
    assert_equal new_post.talk, @post.talk
    assert_equal new_post.user.username, users(:one).username
  end

  test "should get edit" do
    get :edit, id: @post.to_param
    assert_response :success
  end
  
  test "should be redirected to login page when trying to edit others post" do
    get :edit, id: @post_from_other_user.to_param
    assert_redirected_to login_url
  end

  test "should update post" do
    put :update, id: @post.to_param, post: @post.attributes
    assert_redirected_to talk_path(@post.talk)
  end
  
  test "should be redirected to login page when trying to update others post" do
    put :update, id: @post_from_other_user.to_param, post: @post_from_other_user.attributes
    assert_redirected_to login_url
  end

  test "should destroy post" do
    assert_difference('Post.count', -1) do
      delete :destroy, id: @post.to_param
    end

    assert_redirected_to posts_path
  end

  test "should be redirected to login page when trying to destroy other user's post" do
    assert_no_difference('Post.count') do
      delete :destroy, id: @post_from_other_user.to_param
    end

    assert_redirected_to login_url
  end
end
