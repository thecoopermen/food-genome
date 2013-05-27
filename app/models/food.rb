class Food < ActiveRecord::Base
  has_many :genes
  has_many :traits, through: :genes

  attr_accessible :name, :traits

  validates :name, presence: true

  def traits=(traits)
    @traits = traits
  end
end
