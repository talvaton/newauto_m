class ChangeGoodPriceToInt < ActiveRecord::Migration[5.2]
  def change
    change_column :equipment, :good_price, :integer
  end
end
