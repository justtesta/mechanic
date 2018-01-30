class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.integer :merchant_id
      t.integer :skill_id
      t.integer :price

      t.timestamps
    end
  end
end
