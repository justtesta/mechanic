class AddDoneOrdersCountRateToMechanics < ActiveRecord::Migration[5.0]
  def change
    add_column :mechanics, :done_orders_count_rate, :decimal
  end
end
