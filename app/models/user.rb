class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token

  before_save :downcase_email
  before_create :create_activation_digest

  validates :name, presence: true, length: {maximum:  50}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]{2,}\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  validates :password, length: {minimum: 6}, allow_blank: true #blank ok because has_secure_password checks for blank on creation - this is for editing
  has_secure_password

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random, URL-safe, base-64 token ([A-z0-9_\-]{22})
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token for the attribute provided matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest") #self.send - calls method of this name on self.
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user. Opposite of remember
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_password_reset_digest
    self.reset_token = User.new_token
    self.reset_digest = User.digest reset_token
    save
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private
    def downcase_email
      self.email.downcase!
    end
    def create_activation_digest
      self.activation_digest = User.digest(self.activation_token = User.new_token)
    end
end
