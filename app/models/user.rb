class User < ApplicationRecord

  validates :email, uniqueness: true, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  before_save {email.try(:downcase)}
  has_secure_password
end
