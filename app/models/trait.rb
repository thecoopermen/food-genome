class Trait < ActiveRecord::Base
  has_many :genes
  has_many :foods, through: :genes

  attr_accessible :name
end
