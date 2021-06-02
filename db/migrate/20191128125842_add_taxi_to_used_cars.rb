class AddTaxiToUsedCars < ActiveRecord::Migration[5.2]
  def change
    # remove_column :used_cars, :taxi
    # remove_column :used_cars, :taxi_type
    add_column :used_cars, :taxi, :boolean,  default: 0
    add_column :used_cars, :taxi_type, :string
    remove_column :new_cars, :taxi
    drop_table :taxis
  end
end
