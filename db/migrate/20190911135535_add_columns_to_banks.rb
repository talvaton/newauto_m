class AddColumnsToBanks < ActiveRecord::Migration[5.2]
  def change
    add_column :banks, :has_page, :boolean,default: 0
  end
end
