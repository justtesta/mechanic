class CreateNumbers < ActiveRecord::Migration[5.0]
  def change
    create_table :numbers do |t|
      t.string :jdorder_id
      t.string :pwd_umber
      t.string :pwd_umber_default
      t.string :shop_id
      t.string :shop_name
      t.integer :status

      t.timestamps
    end
  end
end
