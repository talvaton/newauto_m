class AddAvailableToNewCars < ActiveRecord::Migration[5.2]
  def change
    add_column :new_cars, :available, :boolean,  default: 1
  end
end
