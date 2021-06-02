class AddCompareToEquipmentDescriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :equipment_descriptions, :compare, :json
    add_column :equipment_descriptions, :comparedesc, :json
  end
end
