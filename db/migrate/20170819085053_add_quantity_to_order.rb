class AddQuantityToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :quantity, :int4
  end
end
