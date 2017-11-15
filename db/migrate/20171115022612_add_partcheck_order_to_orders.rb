class AddPartcheckOrderToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :partcheck_order, :boolean
  end
end
