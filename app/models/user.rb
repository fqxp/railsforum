require 'digest/sha2'

class User < ActiveRecord::Base
  validates :username, :uniqueness => true
  validates :username, :realname, :language, :presence => true

#  validates :language, :inclusion => { :in => I18n.available_locales }
  validates :password, :confirmation => true
  validate :password_must_be_present

  after_initialize :default_values
  
  has_many :talks
  has_many :posts
  has_many :invitations
  
  attr_accessor :password_confirmation
  attr_reader :password

  def self.authenticate(username, password)
    if user = find_by_username(username)
      if user.hashed_password == encrypt_password(password, user.salt)
        user
      end
    end
  end

  def self.encrypt_password(password, salt)
    Digest::SHA2.hexdigest(password + 'whatsup' + salt)
  end

  # Assign plaintext +password+ to the record's +hashed_password+ 
  # attribute after hashing it.
  def password=(password)
    @password = password
    
    if @password.present?
      generate_salt
      self.hashed_password = self.class.encrypt_password(password, salt)
    end
  end
  
  private
    def default_values
      self.language ||= I18n.default_locale
    end
  
    def password_must_be_present
      errors.add :password, I18n.t('.password_missing_msg') unless hashed_password.present?
    end
    
    def generate_salt
      self.salt = self.object_id.to_s + rand.to_s      
    end
end
