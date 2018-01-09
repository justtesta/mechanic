class AddHolidayStartToMechanics < ActiveRecord::Migration[5.0]
  def change
    add_column :mechanics, :holiday_start, :datetime
    add_column :mechanics, :holiday_end, :datetime
  end
end
