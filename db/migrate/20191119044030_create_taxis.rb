class CreateTaxis < ActiveRecord::Migration[5.2]
    def change
        create_table :taxis do |t|
          t.references :new_car, foreign_key: true
          t.references :equipment, foreign_key: true
          t.string :taxi_class
          t.json :images
          t.string :color

          t.timestamps
        end
    end
end