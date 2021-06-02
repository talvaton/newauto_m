class AddHideToEquipment < ActiveRecord::Migration[5.2]
  def change
    add_column :equipment, :hide, :boolean,default: 0
  end
end
