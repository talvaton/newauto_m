class Finances < ActiveRecord::Migration[5.2]
  create_table :finances do |t|
    t.string :name
    t.string :url
    t.json :description

    t.timestamps
  end
end
