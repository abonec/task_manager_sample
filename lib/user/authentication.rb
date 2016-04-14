require 'active_support/concern'
module User::Authentication
  extend ActiveSupport::Concern
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--") if new_record?
    self.crypted_password = encrypt(password)
  end

  def encrypt(password)
    self.class.encrypt password, salt
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  class_methods do
    def register!(email, password)
      user = User.new(email: email, password: password)
      user.save!
      user
    end

    def authenticate(email, password)
      user = User.where(email: email).first
      user && user.authenticated?(password) ? user : nil
    end
    def encrypt(password, salt)
      Digest::SHA1.hexdigest("--#{salt}--#{password}--")
    end
  end

  included do
    attr_accessor :password
    before_save :encrypt_password
  end
end
