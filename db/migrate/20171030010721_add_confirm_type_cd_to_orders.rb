class AddConfirmTypeCdToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :confirm_type_cd, :integer
  end
end
