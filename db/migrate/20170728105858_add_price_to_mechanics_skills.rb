class AddPriceToMechanicsSkills < ActiveRecord::Migration[5.0]
  def change
    add_column :mechanics_skills, :price, :int4
  end
end
