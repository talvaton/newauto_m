class AddMainImgToBrands < ActiveRecord::Migration[5.2]
  def change
    add_column :brands, :main_img, :string
  end
end
