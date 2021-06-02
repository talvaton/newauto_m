class AddColumnsToNewcars < ActiveRecord::Migration[5.2]
  def change
    add_column :new_cars, :archive, :boolean,default: 0
  end
end
