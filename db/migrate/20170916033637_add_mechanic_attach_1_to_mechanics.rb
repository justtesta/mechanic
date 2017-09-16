class AddMechanicAttach1ToMechanics < ActiveRecord::Migration[5.0]
  def change
    add_column :mechanics, :mechanic_attach_1, :string
    add_column :mechanics, :mechanic_attach_2, :string
    add_column :mechanics, :mechanic_attach_3, :string
    add_column :mechanics, :mechanic_attach_4, :string
    add_column :mechanics, :mechanic_attach_5, :string
  end
end
