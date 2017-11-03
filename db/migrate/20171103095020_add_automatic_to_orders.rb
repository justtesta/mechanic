class AddAutomaticToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :automatic, :boolean
  end
end
