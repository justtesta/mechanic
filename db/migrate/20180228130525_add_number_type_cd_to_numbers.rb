class AddNumberTypeCdToNumbers < ActiveRecord::Migration[5.0]
  def change
    add_column :numbers, :number_type_cd, :integer
  end
end
