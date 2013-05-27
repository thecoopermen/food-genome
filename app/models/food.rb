class Food < ActiveRecord::Base
  has_many :genes
  has_many :traits, through: :genes

  attr_accessible :name

  validates :name, presence: true
end
