class User < ActiveRecord::Base
  has_secure_password

  attr_accessible :email, :name, :password_digest

  validates :email, presence: true, uniqueness: true
  validates :name,  presence: true
end
