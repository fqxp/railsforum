require 'test_helper'

class TalksControllerTest < ActionController::TestCase
  setup do
    @talk = talks(:one)
    @post = posts(:one)
  end

  test "should get new" do
    get :new, { :category_id => categories(:one).id }
    assert_response :success
  end

  test "should create talk" do
    assert_difference('Talk.count') do
      post :create, talk: @talk.attributes, post: @post.attributes
    end

    assert_redirected_to talk_path(assigns(:talk))
  end
  
  test "should create post too" do 
    assert_difference('Post.count', +1) do
    #assert_difference('Post.count') do
      post :create, talk: @talk.attributes, post: @post.attributes
    end

    assert_redirected_to talk_path(assigns(:talk))
  end

  test "should show talk" do
    get :show, id: @talk.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @talk.to_param
    assert_response :success
  end

  test "should update talk" do
    put :update, id: @talk.to_param, talk: @talk.attributes
    assert_redirected_to talk_path(assigns(:talk))
  end

  test "should destroy talk" do
    assert_difference('Talk.count', -1) do
      delete :destroy, id: @talk.to_param
    end

    assert_redirected_to talks_path
  end
end
