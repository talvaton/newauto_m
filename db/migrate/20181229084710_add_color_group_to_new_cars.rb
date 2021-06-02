class AddColorGroupToNewCars < ActiveRecord::Migration[5.2]
  def change
    add_column :new_cars, :color_group, :string
  end
end
