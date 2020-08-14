class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true, on: :create
  validates :email, presence: true, uniqueness: {case_sensitive: false}, on: :create
  validates :password_digest, presence: true

  has_many :readers, dependent: :destroy

=begin
PASSWORD_FORMAT = /\A
  (?=.{8,})          # Must contain 8 or more characters
  (?=.*\d)           # Must contain a digit
  (?=.*[a-z])        # Must contain a lower case character
  (?=.*[A-Z])        # Must contain an upper case character
  (?=.*[[:^alnum:]]) # Must contain a symbol
/x


validates :password, 
  presence: true, 
  length: { within: 8..40 }, 
  format: { with: PASSWORD_FORMAT }, 
  confirmation: true, 
  on: :create

validates :password, 
  allow_nil: true, 
  length: { within: 6..40 }, 
  format: { with: PASSWORD_FORMAT }, 
  confirmation: true, 
  on: :update
=end

end
