class CreateEquipment < ActiveRecord::Migration[5.2]
  def change
    create_table :equipment do |t|
      t.references :specification, foreign_key: true
      t.references :equipment_description, foreign_key: true
      t.integer :price
      t.string :suffix
    end
  end
end
