class User < ApplicationRecord

  validates :email, uniqueness: true, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password_confirmation, presence: true

  before_save {email.try(:downcase)}
  has_secure_password
end
