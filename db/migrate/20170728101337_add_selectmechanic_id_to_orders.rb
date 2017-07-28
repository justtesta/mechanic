class AddSelectmechanicIdToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :selectmechanic_id, :int4
  end
end
