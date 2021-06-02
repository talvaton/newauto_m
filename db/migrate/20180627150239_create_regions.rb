class CreateRegions < ActiveRecord::Migration[5.2]
  def change
    create_table :regions do |t|
      t.string :name
      t.string :sklon1
      t.string :sklon2
      t.string :sklon3
    end
  end
end
