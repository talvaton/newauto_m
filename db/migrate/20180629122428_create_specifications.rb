class CreateSpecifications < ActiveRecord::Migration[5.2]
  def change
    create_table :specifications do |t|
      t.references :new_car, foreign_key: true
      t.string :name
      t.string :enginetype
      t.integer :volume
      t.integer :power
      t.float :acceleration
      t.integer :topspeed
      t.float :fuelcity
      t.float :fuelhigh
      t.float :fuelmix
      t.integer :tank
      t.integer :length
      t.integer :width
      t.integer :height
      t.integer :wheelbase
      t.integer :clearance
      t.integer :mass
      t.integer :trunk
      t.string :transmission
      t.string :shorttransmission
      t.string :drive
      t.string :frontsusp
      t.string :rearsusp
      t.string :frontbrakes
      t.string :rearbrakes

    end
  end
end
