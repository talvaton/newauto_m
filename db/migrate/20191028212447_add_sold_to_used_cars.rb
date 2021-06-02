class AddSoldToUsedCars < ActiveRecord::Migration[5.2]
  def change
    add_column :used_cars, :sold, :boolean,  default: 0
  end
end
