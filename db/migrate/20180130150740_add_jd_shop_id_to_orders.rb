class AddJdShopIdToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :jd_order_id, :string
    add_column :orders, :jd_shop_id, :string
    add_column :orders, :jd_order_type_cd, :integer
  end
end
