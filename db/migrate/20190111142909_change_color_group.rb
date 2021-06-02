class ChangeColorGroup < ActiveRecord::Migration[5.2]
  def change
    change_column :new_cars, :color_group, :string, array: true
  end
end
