class AddRepickByToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :repick_by, :integer
  end
end
