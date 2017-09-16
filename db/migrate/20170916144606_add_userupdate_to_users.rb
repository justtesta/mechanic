class AddUserupdateToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :userupdate, :boolean, default: false
  end
end
