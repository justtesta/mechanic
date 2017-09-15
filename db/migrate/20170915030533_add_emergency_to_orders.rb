class AddEmergencyToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :emergency, :boolean, default: false
  end
end
