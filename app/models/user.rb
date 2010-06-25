require 'digest/sha1'

class User < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  attr_accessor :password_confirmation
  validates_confirmation_of :password

  validate :password_non_blank

  def self.authenticate(name, password)
    puts "to authenticate: #{name} with passwword of #{password}"
    user = self.find_by_name(name)
    if user
      expected_password = encrypted_password(password, user.salt)
      puts "hashed password: #{user.hashed_password} but expected(salted) to be #{expected_password}"
      puts "user.password: #{ user.password}"
      if user.hashed_password != expected_password
        #if user.hashed_password != user.password
        user=nil
        puts "authenticated user is null"
      end
    end
    user
  end

  def self.encrypted_password(password, salt)
    string_to_hash = password + "wibble"   + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end

  #password is a virtual attribute?????????????
  def password
    @password
  end
  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    hashed_password = self.hashed_password = User.encrypted_password(self.password, self.salt)
    puts "hashed_password = #{hashed_password}"
    hashed_password
  end


  private
  def password_non_blank
    errors.add(:password, "Missing password") if hashed_password.blank?
  end
end
