class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.string :name
      t.string :phone
      t.string :form_name
      t.string :form_url
      t.integer :send_to_crm
      t.json :utm_info
      t.json :udata
      t.json :other

      t.timestamps
    end
  end
end
