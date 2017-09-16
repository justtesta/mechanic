class AddMechanicAttach1ToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :mechanic_attach_1, :string
    add_column :orders, :mechanic_attach_2, :string
    add_column :orders, :mechanic_attach_3, :string
    add_column :orders, :mechanic_attach_4, :string
  end
end
