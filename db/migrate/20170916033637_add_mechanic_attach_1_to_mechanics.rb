class AddMechanicAttach1ToMechanics < ActiveRecord::Migration[5.0]
  def change
     add_attachment :mechanics, :mechanic_attach_1
     add_attachment :mechanics, :mechanic_attach_2
     add_attachment :mechanics, :mechanic_attach_3
     add_attachment :mechanics, :mechanic_attach_4
     add_attachment :mechanics, :mechanic_attach_5
  end
end
