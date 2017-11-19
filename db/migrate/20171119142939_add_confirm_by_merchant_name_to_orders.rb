class AddConfirmByMerchantNameToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :confirm_by_merchant_name, :string
  end
end
