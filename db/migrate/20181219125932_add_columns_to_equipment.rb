class AddColumnsToEquipment < ActiveRecord::Migration[5.2]
  def change
    add_column :equipment, :other_prices, :json
    add_column :equipment, :good_price, :boolean,default: 1
    add_column :equipment, :updated_at,:datetime
  end
end
