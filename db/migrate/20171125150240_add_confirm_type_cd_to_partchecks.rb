class AddConfirmTypeCdToPartchecks < ActiveRecord::Migration[5.0]
  def change
    add_column :partchecks, :confirm_type_cd, :integer
  end
end
