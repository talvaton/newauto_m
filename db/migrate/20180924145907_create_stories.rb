class CreateStories < ActiveRecord::Migration[5.2]
  def change
    create_table :stories do |t|
      t.string :name
      t.text :newstext
      t.references :brand, foreign_key: true
      t.string :newsImage
      t.string :url

      t.timestamps
    end
  end
end
