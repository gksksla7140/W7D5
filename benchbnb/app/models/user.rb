class User < ApplicationRecord
  validates :username, :session_token, presence: true, uniqueness: true
  validates :password, length: { minimum: 6, allow_nill: true }
  validates :password_digest, presence: true

  attr_reader :password

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)

    if user && is_password?(password)
      return user
    else
      return nil
    end
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(pw)
    BCrypt::Password.new(self.password_digest).is_password?(pw)
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    self.save!
    self.session_token
  end

  private
   def ensure_session_token
     self.session_token ||= SecureRandom.urlsafe_base64

   end
end
