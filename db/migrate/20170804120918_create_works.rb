class CreateWorks < ActiveRecord::Migration[5.0]
  def change
    create_table :works do |t|
      t.int4 :mechanic_id
      t.int4 :skill_id
      t.int4 :price

      t.timestamps
    end
  end
end
