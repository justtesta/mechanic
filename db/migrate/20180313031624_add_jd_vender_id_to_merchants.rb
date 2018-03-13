class AddJdVenderIdToMerchants < ActiveRecord::Migration[5.0]
  def change
    add_column :merchants, :jd_vender_id, :integer
  end
end
