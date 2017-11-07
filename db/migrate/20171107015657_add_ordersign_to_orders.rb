class AddOrdersignToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :ordersign, :string
  end
end
