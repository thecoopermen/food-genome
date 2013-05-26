class Gene < ActiveRecord::Base
  belongs_to :food
  belongs_to :trait
end
