class CreateLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :logs do |t|
      t.string :data
	  t.string :logtype
      t.timestamps
    end
  end
end
