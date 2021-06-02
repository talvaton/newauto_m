class Addcallcentercommentstousedcars < ActiveRecord::Migration[5.2]
  def change
    add_column :used_cars, :special_text, :text
  end
end
