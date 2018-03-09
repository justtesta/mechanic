class AddGroupIdToSkills < ActiveRecord::Migration[5.0]
  def change
    add_column :skills, :group_id, :string
  end
end
