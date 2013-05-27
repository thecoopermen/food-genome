class User < ActiveRecord::Base
  has_secure_password

  attr_accessible :email, :name, :password

  validates :email, presence: true, uniqueness: true
  validates :name,  presence: true
end
