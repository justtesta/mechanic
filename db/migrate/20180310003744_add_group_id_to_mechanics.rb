class AddGroupIdToMechanics < ActiveRecord::Migration[5.0]
  def change
    add_column :mechanics, :group_id, :string
  end
end
