class CreateTempMechanics < ActiveRecord::Migration[5.0]
  def change
    create_table :temp_mechanics do |t|
      t.integer :mechanic_id
      t.string :mechanicname
      t.string :addr
      t.string :tel
      t.integer :lbs_id
      t.string :description

      t.timestamps
    end
  end
end
