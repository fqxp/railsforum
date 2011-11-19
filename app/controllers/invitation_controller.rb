class InviteAddresses < BasicActiveModel
  validates :email_address_list, :presence => true
  validate :email_addresses_have_valid_format
  
  attr_reader :email_address_list
  attr_accessor :email_addresses
  
  @email_addresses = []

  def email_address_list=(value)
    @email_address_list = value
    @email_addresses = []
    @email_address_list.each_line do |address|
      address.chomp!
      address.downcase!
      unless address.empty?
        @email_addresses << address
      end
    end
  end
  
  def email_addresses_have_valid_format
    @email_addresses.each do |address|
      if (/^\w+@(\w+\.)+\w+$/ =~ address).nil?
        errors[:email_address_list] << I18n.t('activemodel.errors.models.invite_addresses.attributes.email_address_list.invalid_email_address', 
                                              :address => address)
      end
    end
  end
  
end

class InvitationController < ApplicationController
  # GET /invite
  def invitation
    @invite_addresses = InviteAddresses.new
    render
  end
  
  # POST /invite
  def invite
    user = User.find(session[:user_id])

    # split addresses and create invitations
    @invite_addresses = InviteAddresses.new(params[:invite_addresses])
    @per_address_info = {}
    if @invite_addresses.valid?
      @invite_addresses.email_addresses.each do |address|
        if invited_user = User.where(:email_address => address).first
          @per_address_info[address] = {
              :status => :user_already_exists,
              :message => I18n.t('.invitation.user_already_exists', 
                                 :address => address, 
                                 :username => invited_user.username)}
        elsif Invitation.where(:email_address => address).exists?
          @per_address_info[address] = {
              :status => :user_already_invited,
              :message => I18n.t('.invitation.user_already_invited', :address => address)}
        else
          invitation = Invitation.create do |i|
            i.email_address = address
            i.invited_by = user
          end
          @per_address_info[address] = {
              :status => :user_invited,
              :message => I18n.t('.invitation.invitation_sent', :address => address)}

          # Send mail with confirmation link
          InvitationSender.invite(invitation, request.host).deliver
        end
      end

      # Show confirmation about e-mails getting sent
      render 'invitation_status'
    else
      # Re-display form
      render 'invitation'
    end
  end
end