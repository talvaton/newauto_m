class CreateBlogs < ActiveRecord::Migration[5.2]
  def change
    create_table :blogs do |t|
      t.references :brand, foreign_key: true
      t.references :new_car, foreign_key: true
      t.json :images
      t.string :url
      t.json :description

      t.timestamps
    end
  end
end
