require 'digest/sha2'

class Invitation < ActiveRecord::Base
  belongs_to :invited_by, :class_name => 'User'
  validates :invited_by, :email_address, :confirm_key, :presence => true
  after_initialize :default_values

  private
    def default_values
      self.confirm_key = Digest::SHA2.hexdigest rand.to_s
    end
end
