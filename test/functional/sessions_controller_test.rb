require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should login" do
    user = users(:one)
    post :create, :username => user.username, :password => 'secret!'
    assert_redirected_to overview_index_url
    assert_equal user.id, session[:user_id]
  end

  test "should fail login" do
    user = users(:one)
    post :create, :username => user.username, :password => 'wrong!'
    assert_redirected_to login_url
    assert_equal nil, session[:user_id]
  end

  test "should logout" do
    get :destroy
    assert_redirected_to login_url
  end

end
