require 'test_helper'

class InvitationControllerTest < ActionController::TestCase
  setup do
  end

  test "should get invitation form" do
    get :invitation
    assert_response :success
    assert_select "form[action=?]", invite_path
  end
  
  test "should save invitation" do
    assert_no_difference('Invitation.count') do
      post :invite, {:invite_addresses => { :email_address_list => users(:one).email_address }}
    end
  end

  test "should not save invitation" do
    assert_difference('Invitation.count') do
      post :invite, {:invite_addresses => { :email_address_list => "doesnotyetexist@example.org" }}
    end
  end
end
