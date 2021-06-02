class CreateUsedCars < ActiveRecord::Migration[5.2]
  def change
    create_table :used_cars do |t|
      t.string :name
      t.string :menutitle
      t.string :url

      t.references :brand, foreign_key: true
      t.integer :price
      t.integer :odometer
      t.integer :owners
      t.string :condition
      t.integer :year
      t.string :vin
      t.string :color
      t.boolean :avito
      t.string :car_type
      t.json :images
      t.string :transmission
      t.decimal :volume,precision: 10, scale: 2
      t.integer :power

      t.json :complectation
      t.string :drive
      t.boolean :used
      t.boolean :hide

      t.timestamps
    end
  end
end
