class CreateBrands < ActiveRecord::Migration[5.2]
  def change
    create_table :brands do |t|

      t.string :title
      t.string :menutitle
      t.json :description

      t.string :logo
      t.string :logoblack
      t.string :cert

      t.string :url

      t.boolean :official,default: true

      t.boolean :menu_show,default: false

      t.boolean :hide,default: true

      t.timestamps
    end
  end
end
