class AddFromsourceToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :fromsource, :string
  end
end
