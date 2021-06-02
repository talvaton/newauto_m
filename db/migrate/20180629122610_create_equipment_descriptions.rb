class CreateEquipmentDescriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :equipment_descriptions do |t|
      t.references :new_car, foreign_key: true
      t.string :name
      t.text :description
    end
  end
end
