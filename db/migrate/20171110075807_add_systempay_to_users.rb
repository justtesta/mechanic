class AddSystempayToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :systempay, :boolean
  end
end
