require 'digest/sha2'

class User < ActiveRecord::Base
  validates :username, :uniqueness => true
  validates :username, :realname, :presence => true
  validates :password, :confirmation => true
  validate :password_must_be_present
  
  has_many :talks
  has_many :posts
  
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
  
    def password_must_be_present
      errors.add(:password, "Missing password") unless hashed_password.present?
    end
    
    def generate_salt
      self.salt = self.object_id.to_s + rand.to_s      
    end
end
