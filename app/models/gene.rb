class Gene < ActiveRecord::Base
  belongs_to :food
  belongs_to :trait

  validates :food,  presence: true
  validates :trait, presence: true
end
