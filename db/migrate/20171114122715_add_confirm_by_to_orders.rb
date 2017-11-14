class AddConfirmByToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :confirm_by, :integer
  end
end
