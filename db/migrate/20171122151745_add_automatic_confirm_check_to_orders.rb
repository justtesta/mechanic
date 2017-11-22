class AddAutomaticConfirmCheckToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :automatic_confirm_check, :boolean
    add_column :orders, :automatic_repick_check, :boolean
  end
end
