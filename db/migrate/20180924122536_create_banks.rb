class CreateBanks < ActiveRecord::Migration[5.2]
  def change
    create_table :banks do |t|
      t.string :name
      t.string :url
      t.string :image
      t.json :description

      t.timestamps
    end
  end
end
