class AddInitialToServices < ActiveRecord::Migration[5.0]
  def change
  	Service.create(name: "可上门")
  end
end
