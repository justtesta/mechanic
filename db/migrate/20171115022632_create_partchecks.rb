class CreatePartchecks < ActiveRecord::Migration[5.0]
  def change
    create_table :partchecks do |t|
      t.integer :order_id
      t.integer :quoted_price
      t.integer :quantity
      t.integer :mechanic_income
      t.integer :procedure_price
      t.integer :confirm_by

      t.timestamps
    end
  end
end
