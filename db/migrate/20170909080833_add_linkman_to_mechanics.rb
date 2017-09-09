class AddLinkmanToMechanics < ActiveRecord::Migration[5.0]
  def change
    add_column :mechanics, :linkman, :string
  end
end
