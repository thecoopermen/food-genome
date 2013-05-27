class Food < ActiveRecord::Base
  has_many :genes
  has_many :traits, through: :genes

  attr_accessible :name, :traits

  validates :name, presence: true

  def trait_names=(trait_names)
    @trait_names = trait_names
  end

  def trait_names
    @trait_names
  end
end
