class AddRepickByMerchantNameToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :repick_by_merchant_name, :string
  end
end
