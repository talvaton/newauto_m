class AddSpecialTextToNewCars < ActiveRecord::Migration[5.2]
  def change
    add_column :new_cars, :special_text, :text
  end
end
