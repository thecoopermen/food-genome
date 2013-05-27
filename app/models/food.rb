class Food < ActiveRecord::Base
  has_many :genes
  has_many :traits, through: :genes

  attr_accessible :name, :trait_names

  validates :name, presence: true

  def trait_names=(trait_names)
    trait_names.each do |name|
      self.traits << Trait.find_or_create_by_name(name.downcase)
    end
  end

  def trait_names
    self.traits.pluck(:name)
  end
end
