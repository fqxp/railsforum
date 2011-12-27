require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  def setup
    # skip log in defined in test helper
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_select 'h1', 'Please log in'
  end
  
  test "should get new in german" do
    @request.env['HTTP_ACCEPT_LANGUAGE'] = 'de' #-de,de;q=0.8'
    get :new
    assert_response :success
    assert_select 'h1', 'Bitte anmelden'
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
