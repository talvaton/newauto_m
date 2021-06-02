class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.string :name
      t.text :rev_text
      t.references :new_car, foreign_key: true
      t.string :image
      t.timestamps
    end
  end
end
