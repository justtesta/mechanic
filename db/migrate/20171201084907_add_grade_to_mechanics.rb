class AddGradeToMechanics < ActiveRecord::Migration[5.0]
  def change
    add_column :mechanics, :grade_cd, :integer
  end
end
