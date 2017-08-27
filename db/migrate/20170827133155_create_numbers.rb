class CreateNumbers < ActiveRecord::Migration[5.0]
  def change
    create_table :numbers do |t|
      t.string :jdorder_id
      t.string :pwd_number
      t.string :pwd_number_default
      t.string :shop_id
      t.string :shop_name
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
