class CreateGenes < ActiveRecord::Migration

  def change
    create_table :genes do |t|
      t.references :food
      t.references :trait
      t.timestamps
    end
  end
end
