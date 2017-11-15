class AddRemarkToPartcheck < ActiveRecord::Migration[5.0]
  def change
    add_column :partchecks, :remark, :string
  end
end
