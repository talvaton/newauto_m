class AddTaxiToNewCars < ActiveRecord::Migration[5.2]
  def change
    add_column :new_cars, :taxi, :boolean,  default: 0
  end
end