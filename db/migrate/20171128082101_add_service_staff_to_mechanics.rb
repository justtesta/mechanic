class AddServiceStaffToMechanics < ActiveRecord::Migration[5.0]
  def change
    add_column :mechanics, :service_staff, :string
  end
end
