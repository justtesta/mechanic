class CreateWorks < ActiveRecord::Migration[5.0]
  def change
    create_table :works do |t|
      t.int :mechanic_id
      t.int :skill_id
      t.int :price

      t.timestamps
    end
  end
end
