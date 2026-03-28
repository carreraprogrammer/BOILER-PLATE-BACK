class User < ApplicationRecord
  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles
  has_many :permissions, through: :roles

  validates :email, presence: true, uniqueness: true
  validates :encrypted_password, presence: true, unless: :oauth_user?
  validates :name, presence: true

  before_validation :ensure_encrypted_password_for_oauth_user

  def oauth_user?
    auth_provider.present?
  end

  private

  def ensure_encrypted_password_for_oauth_user
    return unless oauth_user?
    return if encrypted_password.present?

    self.encrypted_password = BCrypt::Password.create(SecureRandom.hex(32))
  end
end
