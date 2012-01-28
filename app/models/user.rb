require 'digest/sha2'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :invitable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :realname, :password, :password_confirmation, :remember_me, :language, :avatar
 
  validates :username, :uniqueness => true
  #validates :username, :realname, :language, :presence => true
  validates :username, :language, :presence => true

#  validates :language, :inclusion => { :in => I18n.available_locales }
  validates :password, :confirmation => true
#  validate :password_must_be_present
  
  has_attached_file :avatar, :styles => { :tiny => '16x16', :thumb => '48x48', :medium => '300x300' },
    :default_url => '/images/avatar-default.png'

  after_initialize :default_values
  
  has_many :talks
  has_many :posts
  has_many :invitations
  has_many :talk_visits
  
  private
    def default_values
      self.language ||= I18n.default_locale
    end
end
