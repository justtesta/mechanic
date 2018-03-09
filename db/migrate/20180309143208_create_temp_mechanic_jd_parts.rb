class CreateTempMechanicJdParts < ActiveRecord::Migration[5.0]
  def change
    create_table :temp_mechanic_jd_parts do |t|
      t.string :mechanic_num
      t.string :name
      t.string :unique_id
      t.string :group_id
      t.integer :mechanic_id

      t.timestamps
    end
  end
end
