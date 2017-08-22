class CreateServices < ActiveRecord::Migration[5.0]
  def change
    create_table :services do |t|
      t.string :name

      t.timestamps
    end
    Service.create(name: "轮胎到店")
    create_join_table :mechanics, :services
  end
end
