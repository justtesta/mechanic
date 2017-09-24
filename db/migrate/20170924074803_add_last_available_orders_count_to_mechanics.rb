class AddLastAvailableOrdersCountToMechanics < ActiveRecord::Migration[5.0]
  def change
    add_column :mechanics, :last_available_orders_count, :integer
    add_column :mechanics, :last_done_orders_count, :integer
  end
end
