class AddUserupdateToMechanics < ActiveRecord::Migration[5.0]
  def change
    add_column :mechanics, :userupdate, :boolean, default: false
  end
end
