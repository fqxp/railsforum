require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    @user_params = { 
        :username => 'benjy_mouse',
        :realname => 'Benjy Mouse',
        :password => 'secret!',
        :password_confirmation => 'secret!'
      }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: @user_params
    end

    assert_redirected_to users_path
  end

  test "should show user" do
    get :show, id: @user.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user.to_param
    assert_response :success
  end

  test "should update user" do
    put :update, id: @user.to_param, user: @user_params
    assert_redirected_to root_url
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user.to_param
    end

    assert_redirected_to users_path
  end
  
  test "should get edit password page" do
    get :edit_password, id: @user.to_param
    assert_response :success
  end
  
  test "should change password" do
    put :update_password, id: @user.id, :current_password => 'secret!', 
        :user => {:password => 'evenmoresecret!', :password_confirmation => 'evenmoresecret!'}
    assert_redirected_to edit_user_path(@user)
    assert_nil User.authenticate('user_one', 'secret!')
    assert_not_nil User.authenticate('user_one', 'evenmoresecret!')
  end
end
