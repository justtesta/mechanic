class CreateWorks < ActiveRecord::Migration[5.0]
  def change
    create_table :works do |t|
      t.integer :mechanic_id
      t.integer :skill_id
      t.integer :price

      t.timestamps
    end
  end
end
