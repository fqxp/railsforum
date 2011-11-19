require 'test_helper'

class InvitationSenderTest < ActionMailer::TestCase
  #include ActionDispatch::Routing
  #include ActionView::Helpers::UrlHelper
  include Rails.application.routes.url_helpers
  
  test "invite" do
    invitation = invitations(:one)
    mail = InvitationSender.invite(invitation, 'localhost')
    assert_equal "Invite", mail.subject
    assert_equal [invitation.email_address], mail.to
    assert_equal ["from@example.com"], mail.from
    url = register_url(:host => 'localhost', :confirm_key => invitation.confirm_key)
    assert url.in? mail.body.encoded
  end
end
