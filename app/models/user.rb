class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  enum :auth_source, { email: 0, google: 1 }
  enum :role, { user: 0, admin: 1 }

  devise :database_authenticatable,
         :registerable,
         :validatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: self

  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  def password_required?
    auth_source == 'email'
  end
end

# users table (Schema)
# id
# full_name
# email
# encrypted_password
# auth_source
# jti
# created_at
# updated_at