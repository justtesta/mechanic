class AddOrderIdToNumbers < ActiveRecord::Migration[5.0]
  def change
    add_column :numbers, :order_id, :integer
  end
end
