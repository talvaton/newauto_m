class CreateNewCars < ActiveRecord::Migration[5.2]
  def change
    create_table :new_cars do |t|
      t.references :brand, foreign_key: true
      t.string :name
      t.string :russian_name
      t.string :menutitle
      t.json :description
      t.boolean :old, default: false
      t.string :url

      t.integer :discount,default: 50000
      t.integer :discount_credit,default: 40000
      t.integer :discount_tradein,default: 60000
      t.boolean :half_discount,default: false
      t.string :car_type
      t.string :car_link, array:true
      t.string :country
      t.string :warranty
      t.string :special_options, array:true
      t.string :video_link

      t.json :colors
      t.json :color_options
      t.json :images
      t.json :images360

      t.boolean :hide,default: true

      t.timestamps
    end
  end
end
