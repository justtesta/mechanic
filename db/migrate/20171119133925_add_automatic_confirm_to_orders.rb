class AddAutomaticConfirmToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :automatic_confirm, :boolean
  end
end
