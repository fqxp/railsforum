class InvitationSender < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invitation_sender.invite.subject
  #
  def invite(invitation, www_host)
    @invitation = invitation
    @www_host = www_host
    
    mail :to => invitation.email_address
  end
end
