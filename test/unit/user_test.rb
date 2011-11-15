require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
  end
  
  test "setting password should not save plain password" do
    @user.password = 'secret!'
    assert_not_equal @user.hashed_password, 'secret!'
  end
  
  test "authenticate should return user" do
    @user.password = 'secret!'
    @user.save
    assert_equal @user, User.authenticate(@user.username, 'secret!')
  end

  test "authenticate should fail" do
    @user.password = 'secret!'
    @user.save
    assert_equal nil, User.authenticate(@user.username, 'wrong!')
  end
end
