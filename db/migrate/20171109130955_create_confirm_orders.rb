class CreateConfirmOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :confirm_orders do |t|
      t.integer :order_id

      t.timestamps
    end
  end
end
