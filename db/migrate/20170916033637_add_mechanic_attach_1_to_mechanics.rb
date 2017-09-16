class AddMechanicAttach1ToMechanics < ActiveRecord::Migration[5.0]
  def change
    add_column :mechanics, :mechanic_attach_1, :attachment
    add_column :mechanics, :mechanic_attach_2, :attachment
    add_column :mechanics, :mechanic_attach_3, :attachment
    add_column :mechanics, :mechanic_attach_4, :attachment
    add_column :mechanics, :mechanic_attach_5, :attachment
  end
end
