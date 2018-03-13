class AddVenderidToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :venderid, :string
  end
end
